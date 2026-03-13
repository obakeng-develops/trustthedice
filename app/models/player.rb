class Player < ApplicationRecord
  belongs_to :team

  validates :name, presence: true

  after_initialize :set_defaults

  private

  def set_defaults
    self.is_host = false if is_host.nil?
    self.online = true if online.nil?
  end
end
