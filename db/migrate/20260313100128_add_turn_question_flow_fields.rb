class AddTurnQuestionFlowFields < ActiveRecord::Migration[8.1]
  def change
    add_column :turns, :question_id, :integer unless column_exists?(:turns, :question_id)
    add_column :turns, :question_payload, :json unless column_exists?(:turns, :question_payload)
    add_column :turns, :question_source, :string unless column_exists?(:turns, :question_source)
    add_column :turns, :chaos_roll, :integer unless column_exists?(:turns, :chaos_roll)
    add_column :turns, :chaos_effect, :string unless column_exists?(:turns, :chaos_effect)
    add_column :turns, :swap_target_team_id, :integer unless column_exists?(:turns, :swap_target_team_id)
    add_column :turns, :swap_roll, :integer unless column_exists?(:turns, :swap_roll)
    add_column :turns, :swap_difficulty, :string unless column_exists?(:turns, :swap_difficulty)
    add_column :turns, :timer_started_at, :datetime unless column_exists?(:turns, :timer_started_at)
    add_column :turns, :timer_seconds, :integer unless column_exists?(:turns, :timer_seconds)
    add_column :turns, :steal_open, :boolean, default: false, null: false unless column_exists?(:turns, :steal_open)
    add_column :turns, :steal_started_at, :datetime unless column_exists?(:turns, :steal_started_at)
    add_column :turns, :steal_winner_team_id, :integer unless column_exists?(:turns, :steal_winner_team_id)
    add_column :turns, :steal_winner_player_id, :integer unless column_exists?(:turns, :steal_winner_player_id)
    add_column :turns, :reroll_topic_used, :boolean, default: false, null: false unless column_exists?(:turns, :reroll_topic_used)
    add_column :turns, :reroll_difficulty_used, :boolean, default: false, null: false unless column_exists?(:turns, :reroll_difficulty_used)

    add_index :turns, :question_id unless index_exists?(:turns, :question_id)
    add_index :turns, :steal_open unless index_exists?(:turns, :steal_open)
    add_index :turns, :steal_winner_team_id unless index_exists?(:turns, :steal_winner_team_id)
    add_index :turns, :steal_winner_player_id unless index_exists?(:turns, :steal_winner_player_id)
    add_index :turns, :swap_target_team_id unless index_exists?(:turns, :swap_target_team_id)
  end
end
