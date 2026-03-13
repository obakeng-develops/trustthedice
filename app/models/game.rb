class Game < ApplicationRecord
  has_many :teams, dependent: :destroy
  has_many :players, through: :teams
  has_many :rounds, dependent: :destroy
  has_many :turns, through: :rounds

  validates :status, presence: true
  validates :host_token, presence: true, uniqueness: true

  before_validation :ensure_host_token, on: :create
  after_initialize :set_defaults

  STATUSES = %w[lobby round_setup question steal scoreboard].freeze

  def lobby?
    status == "lobby"
  end

  private

  def ensure_host_token
    self.host_token ||= SecureRandom.hex(16)
  end

  def set_defaults
    self.status ||= "lobby"
    self.settings ||= { "chaos_enabled" => true, "timer_seconds" => 30, "question_mix" => "auto" }
  end
end
