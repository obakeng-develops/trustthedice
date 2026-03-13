# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
require "json"

sa_pack_path = Rails.root.join("db/seed_data/sa_questions.json")

if sa_pack_path.exist?
  questions = JSON.parse(sa_pack_path.read)

  questions.each do |attrs|
    Question.find_or_create_by!(prompt: attrs.fetch("prompt"), source: attrs.fetch("source")) do |question|
      question.topic = attrs.fetch("topic")
      question.difficulty = attrs.fetch("difficulty")
      question.qtype = attrs.fetch("qtype")
      question.correct_answer = attrs.fetch("correct_answer")
      question.aliases = attrs.fetch("aliases", [])
      question.options = attrs.fetch("options", [])
      question.region = attrs.fetch("region")
    end
  end
end
