class Turn < ApplicationRecord
  belongs_to :round
  belongs_to :team
  belongs_to :rep, class_name: "Player", optional: true
  belongs_to :steal_team, class_name: "Team", optional: true
  belongs_to :question, optional: true
  belongs_to :steal_winner_team, class_name: "Team", optional: true
  belongs_to :steal_winner_player, class_name: "Player", optional: true
  belongs_to :swap_target_team, class_name: "Team", optional: true

  has_many :buzzes, dependent: :destroy

  TOPICS = [
    "General Knowledge",
    "History",
    "Sports",
    "Science",
    "Entertainment",
    "Geography"
  ].freeze

  DIFFICULTIES = [ "easy", "medium", "hard" ].freeze

  BASE_POINTS = {
    "easy" => 2,
    "medium" => 4,
    "hard" => 5
  }.freeze
end
