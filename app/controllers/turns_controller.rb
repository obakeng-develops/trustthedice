class TurnsController < ApplicationController
  before_action :set_turn, only: [
    :roll_topic,
    :roll_difficulty,
    :roll_chaos,
    :set_chaos_effect,
    :swap_difficulty,
    :set_lifeline,
    :toggle_multiplier,
    :assign_question,
    :start_timer,
    :mark_correct,
    :mark_incorrect,
    :award_steal,
    :open_steal,
    :close_steal
  ]

  def create
    game = Game.find(params[:id])
    round = game.current_round
    unless round
      redirect_to host_game_path(game, token: game.host_token)
      return
    end

    team = game.teams.find(params[:turn][:team_id])
    rep_id = round&.reps&.[](team.id.to_s)

    round.turns.create!(
      team: team,
      rep_id: rep_id,
      topic: "pending",
      difficulty: "pending",
      timer_seconds: game.settings["timer_seconds"] || 30
    )

    GameBroadcaster.broadcast(game)
    redirect_to host_game_path(game, token: game.host_token)
  end

  def roll_topic
    @turn.update!(topic: Turn::TOPICS.sample)
    broadcast
    head :ok
  end

  def roll_difficulty
    roll = rand(1..6)
    difficulty = Turn::DIFFICULTY_RULES.find { |range, _| range.cover?(roll) }&.last

    @turn.update!(difficulty: difficulty)
    broadcast
    head :ok
  end

  def roll_chaos
    roll = rand(1..6)
    outcome = if roll <= 2
      "swap_team"
    elsif roll <= 4
      "swap_difficulty"
    else
      "double_choice"
    end

    @turn.update!(chaos_roll: roll, chaos_outcome: outcome, chaos_effect: nil)
    broadcast
    head :ok
  end

  def set_chaos_effect
    effect = params[:chaos_effect]
    return head :unprocessable_entity unless %w[double_points double_penalty].include?(effect)

    @turn.update!(chaos_effect: effect)
    broadcast
    head :ok
  end

  def swap_difficulty
    target_team = Team.find(params[:swap_target_team_id])
    roll = rand(1..6)
    rolled_difficulty = Turn::DIFFICULTY_RULES.find { |range, _| range.cover?(roll) }&.last

    updates = {
      swap_target_team_id: target_team.id,
      swap_roll: roll,
      swap_difficulty: rolled_difficulty
    }

    if Turn::BASE_POINTS[rolled_difficulty].to_i < Turn::BASE_POINTS[@turn.difficulty].to_i
      updates[:difficulty] = rolled_difficulty
    end

    @turn.update!(updates)
    broadcast
    head :ok
  end

  def set_lifeline
    lifeline = params[:lifeline_type]
    return head :unprocessable_entity unless %w[single team none].include?(lifeline)

    @turn.update!(lifeline_type: lifeline == "none" ? nil : lifeline)
    broadcast
    head :ok
  end

  def toggle_multiplier
    @turn.update!(multiplier: !@turn.multiplier?)
    broadcast
    head :ok
  end

  def assign_question
    return head :unprocessable_entity if @turn.topic == "pending" || @turn.difficulty == "pending"

    question = QuestionPicker.new.pick(topic: @turn.topic, difficulty: @turn.difficulty)
    return head :unprocessable_entity unless question

    if question.is_a?(Question) && question.persisted?
      @turn.update!(question: question, question_payload: nil, question_source: question.source)
    else
      payload = {
        topic: question.topic,
        difficulty: question.difficulty,
        qtype: question.qtype,
        prompt: question.prompt,
        correct_answer: question.correct_answer,
        aliases: question.aliases,
        options: question.options,
        source: question.source,
        region: question.region
      }
      @turn.update!(question: nil, question_payload: payload, question_source: question.source)
    end

    broadcast
    head :ok
  end

  def start_timer
    seconds = @turn.timer_seconds || @turn.round.game.settings["timer_seconds"] || 30
    @turn.update!(timer_started_at: Time.current, timer_seconds: seconds)
    broadcast
    head :ok
  end

  def mark_correct
    points = ScoreCalculator.call(@turn, correct: true)
    @turn.update!(answered_correct: true, points_awarded: points)
    @turn.team.update!(score: @turn.team.score + points)
    broadcast
    head :ok
  end

  def mark_incorrect
    points = ScoreCalculator.call(@turn, correct: false)
    @turn.update!(answered_correct: false, points_awarded: points)
    @turn.team.update!(score: @turn.team.score + points)
    broadcast
    head :ok
  end

  def award_steal
    return head :unprocessable_entity unless @turn.steal_winner_team_id

    correct = params[:steal_correct] == "true"
    @turn.update!(steal_team_id: @turn.steal_winner_team_id, steal_correct: correct)

    if correct
      team = Team.find(@turn.steal_winner_team_id)
      points = ScoreCalculator.call(@turn, correct: true)
      team.update!(score: team.score + points)
    end

    broadcast
    head :ok
  end

  def open_steal
    @turn.update!(steal_open: true, steal_started_at: Time.current, steal_winner_team_id: nil, steal_winner_player_id: nil)
    broadcast
    head :ok
  end

  def close_steal
    @turn.update!(steal_open: false)
    broadcast
    head :ok
  end

  private

  def set_turn
    @turn = Turn.find(params[:id])
  end

  def broadcast
    GameBroadcaster.broadcast(@turn.round.game)
  end
end
