class ScoreCalculator
  def self.call(turn, correct:)
    base = Turn::BASE_POINTS.fetch(turn.difficulty, 0)
    points = base

    points *= 2 if turn.multiplier?

    if correct && turn.chaos_effect == "double_points"
      points *= 2
    elsif !correct && turn.chaos_effect == "double_penalty"
      points *= 2
    end

    correct ? points : -points
  end
end
