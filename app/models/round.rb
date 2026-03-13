class Round < ApplicationRecord
  belongs_to :game
  has_many :turns, dependent: :destroy

  validates :number, presence: true

  after_initialize :set_defaults

  private

  def set_defaults
    self.question_index ||= 0
    self.reps ||= {}
  end
end
