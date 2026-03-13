class Team < ApplicationRecord
  belongs_to :game
  has_many :players, dependent: :destroy
  has_many :turns, dependent: :nullify

  validates :name, presence: true

  after_initialize :set_defaults

  private

  def set_defaults
    self.score ||= 0
    self.lifeline_single_used = false if lifeline_single_used.nil?
    self.lifeline_team_used = false if lifeline_team_used.nil?
  end
end
