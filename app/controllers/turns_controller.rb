class TurnsController < ApplicationController
  before_action :set_turn, only: [
    :update_manual,
    :assign_question,
    :mark_correct,
    :mark_incorrect,
    :open_steal,
    :close_steal,
    :award_steal
  ]

  def create
    game = Game.find(params[:id])
    round = game.rounds.order(number: :desc).first
    return redirect_to host_game_path(game, token: game.host_token) unless round

    team = game.teams.find(params[:turn][:team_id])
    rep_id = round.reps[team.id.to_s]

    round.turns.create!(
      team: team,
      rep_id: rep_id,
      topic: nil,
      difficulty: nil,
      timer_seconds: game.settings["timer_seconds"] || 30
    )
    GameBroadcaster.broadcast(game)
    redirect_to host_game_path(game, token: game.host_token)
  end

  def update_manual
    @turn.update!(manual_params)
    GameBroadcaster.broadcast(@turn.round.game)
    redirect_to host_game_path(@turn.round.game, token: @turn.round.game.host_token)
  end

  def assign_question
    if @turn.topic.blank? || @turn.difficulty.blank?
      flash[:alert] = "Topic and difficulty must be set before assigning a question."
      return redirect_to host_game_path(@turn.round.game, token: @turn.round.game.host_token)
    end

    question = QuestionPicker.new.pick(topic: @turn.topic, difficulty: @turn.difficulty)
    if question.nil?
      flash[:alert] = "No question available for that topic and difficulty."
      return redirect_to host_game_path(@turn.round.game, token: @turn.round.game.host_token)
    end

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

    GameBroadcaster.broadcast(@turn.round.game)
    redirect_to host_game_path(@turn.round.game, token: @turn.round.game.host_token)
  end

  def mark_correct
    points = ScoreCalculator.call(@turn, correct: true)
    @turn.update!(answered_correct: true, points_awarded: points)
    @turn.team.update!(score: @turn.team.score + points)
    @turn.round.increment_rep_question_count(@turn.rep_id)
    GameBroadcaster.broadcast(@turn.round.game)
    redirect_to host_game_path(@turn.round.game, token: @turn.round.game.host_token)
  end

  def mark_incorrect
    points = ScoreCalculator.call(@turn, correct: false)
    @turn.update!(answered_correct: false, points_awarded: points)
    @turn.team.update!(score: @turn.team.score + points)
    @turn.round.increment_rep_question_count(@turn.rep_id)
    @turn.update!(steal_open: true, steal_started_at: Time.current, steal_winner_team_id: nil, steal_winner_player_id: nil)
    GameBroadcaster.broadcast(@turn.round.game)
    redirect_to host_game_path(@turn.round.game, token: @turn.round.game.host_token)
  end

  def open_steal
    @turn.update!(steal_open: true, steal_started_at: Time.current, steal_winner_team_id: nil, steal_winner_player_id: nil)
    GameBroadcaster.broadcast(@turn.round.game)
    redirect_to host_game_path(@turn.round.game, token: @turn.round.game.host_token)
  end

  def close_steal
    @turn.update!(steal_open: false)
    GameBroadcaster.broadcast(@turn.round.game)
    redirect_to host_game_path(@turn.round.game, token: @turn.round.game.host_token)
  end

  def award_steal
    return redirect_to host_game_path(@turn.round.game, token: @turn.round.game.host_token) unless @turn.steal_winner_team_id

    correct = params[:steal_correct] == "true"
    @turn.update!(steal_team_id: @turn.steal_winner_team_id, steal_correct: correct)

    if correct
      team = Team.find(@turn.steal_winner_team_id)
      points = ScoreCalculator.call(@turn, correct: true)
      team.update!(score: team.score + points)
    end

    GameBroadcaster.broadcast(@turn.round.game)
    redirect_to host_game_path(@turn.round.game, token: @turn.round.game.host_token)
  end

  private

  def set_turn
    @turn = Turn.find(params[:id])
  end

  def manual_params
    params.require(:turn).permit(:topic, :difficulty, :reroll_topic_used, :reroll_difficulty_used)
  end
end
