class Round < ApplicationRecord
  belongs_to :game
  has_many :turns, dependent: :destroy

  validates :number, presence: true

  after_initialize :set_defaults

  private

  def set_defaults
    self.question_index ||= 0
    self.reps ||= {}
    self.rep_question_counts ||= {}
  end

  public

  def increment_rep_question_count(rep_id)
    return if rep_id.blank?

    key = rep_id.to_s
    counts = rep_question_counts || {}
    counts[key] = counts.fetch(key, 0).to_i + 1
    update!(rep_question_counts: counts)
  end

  def rep_question_count(rep_id)
    return 0 if rep_id.blank?

    rep_question_counts.fetch(rep_id.to_s, 0).to_i
  end
end
