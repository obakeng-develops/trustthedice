require "cgi"
require "json"
require "net/http"

class OpenTriviaClient
  CATEGORY_MAP = {
    "General Knowledge" => 9,
    "History" => 23,
    "Sports" => 21,
    "Science" => 17,
    "Entertainment" => 11,
    "Geography" => 22
  }.freeze

  def fetch(topic:, difficulty:)
    category = CATEGORY_MAP[topic]
    return unless category

    uri = URI("https://opentdb.com/api.php")
    uri.query = URI.encode_www_form(
      amount: 1,
      category: category,
      difficulty: difficulty,
      type: "multiple"
    )

    response = Net::HTTP.get_response(uri)
    return unless response.is_a?(Net::HTTPSuccess)

    payload = JSON.parse(response.body)
    data = payload["results"]&.first
    return unless data

    build_question(data, topic, difficulty)
  rescue JSON::ParserError
    nil
  end

  private

  def build_question(data, topic, difficulty)
    correct = normalize_text(data["correct_answer"])
    incorrect = Array(data["incorrect_answers"]).map { |item| normalize_text(item) }
    prompt = normalize_text(data["question"])

    Question.new(
      topic: topic,
      difficulty: difficulty,
      qtype: "mc",
      prompt: prompt,
      correct_answer: correct,
      options: [ correct ] + incorrect,
      aliases: [],
      source: "opentdb",
      region: "global"
    )
  end

  def normalize_text(text)
    CGI.unescapeHTML(text.to_s)
  end
end
