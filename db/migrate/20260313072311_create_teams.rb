class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.references :game, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :score, default: 0, null: false
      t.boolean :lifeline_single_used, default: false, null: false
      t.boolean :lifeline_team_used, default: false, null: false

      t.timestamps
    end
  end
end
