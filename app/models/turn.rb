class Turn < ApplicationRecord
  belongs_to :round
  belongs_to :team
  belongs_to :rep, class_name: "Player", optional: true
  belongs_to :steal_team, class_name: "Team", optional: true

  has_many :buzzes, dependent: :destroy

  validates :topic, presence: true
  validates :difficulty, presence: true
end
