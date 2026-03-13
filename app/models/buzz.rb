class Buzz < ApplicationRecord
  belongs_to :turn
  belongs_to :team
  belongs_to :player
end
