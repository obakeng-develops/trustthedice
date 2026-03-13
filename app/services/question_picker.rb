class QuestionPicker
  def pick(topic:, difficulty:)
    sa_question = Question.where(topic: topic, difficulty: difficulty, source: "sa_pack")
      .order(Arel.sql("RANDOM()"))
      .first
    return sa_question if sa_question

    local_question = Question.where(topic: topic, difficulty: difficulty)
      .order(Arel.sql("RANDOM()"))
      .first
    return local_question if local_question

    OpenTriviaClient.new.fetch(topic: topic, difficulty: difficulty)
  end
end
