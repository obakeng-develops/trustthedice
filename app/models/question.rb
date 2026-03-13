class Question < ApplicationRecord
  validates :topic, :difficulty, :qtype, :prompt, :correct_answer, presence: true

  after_initialize :set_defaults

  private

  def set_defaults
    self.aliases ||= []
    self.options ||= []
  end
end
