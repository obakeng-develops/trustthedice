class CreateRounds < ActiveRecord::Migration[8.0]
  def change
    create_table :rounds do |t|
      t.references :game, null: false, foreign_key: true
      t.integer :number, null: false
      t.json :reps, default: {}
      t.integer :question_index, default: 0, null: false

      t.timestamps
    end
  end
end
