class AddQuestionAndFlowFieldsToTurns < ActiveRecord::Migration[8.0]
  def change
    add_column :turns, :question_id, :integer
    add_column :turns, :question_payload, :json
    add_column :turns, :question_source, :string
    add_column :turns, :chaos_roll, :integer
    add_column :turns, :chaos_effect, :string
    add_column :turns, :swap_target_team_id, :integer
    add_column :turns, :swap_roll, :integer
    add_column :turns, :swap_difficulty, :string
    add_column :turns, :timer_started_at, :datetime
    add_column :turns, :timer_seconds, :integer

    add_index :turns, :question_id
    add_index :turns, :swap_target_team_id
  end
end
