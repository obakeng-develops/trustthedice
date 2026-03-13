class AddStealFieldsToTurns < ActiveRecord::Migration[8.0]
  def change
    add_column :turns, :steal_open, :boolean, default: false, null: false
    add_column :turns, :steal_started_at, :datetime
    add_column :turns, :steal_winner_team_id, :integer
    add_column :turns, :steal_winner_player_id, :integer

    add_index :turns, :steal_open
    add_index :turns, :steal_winner_team_id
    add_index :turns, :steal_winner_player_id
  end
end
