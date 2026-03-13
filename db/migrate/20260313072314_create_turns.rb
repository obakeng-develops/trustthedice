class CreateTurns < ActiveRecord::Migration[8.0]
  def change
    create_table :turns do |t|
      t.references :round, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :rep_id
      t.string :topic
      t.string :difficulty
      t.string :chaos_outcome
      t.boolean :multiplier, default: false, null: false
      t.string :lifeline_type
      t.boolean :answered_correct
      t.integer :steal_team_id
      t.boolean :steal_correct
      t.integer :points_awarded

      t.timestamps
    end

    add_index :turns, :rep_id
    add_index :turns, :steal_team_id
  end
end
