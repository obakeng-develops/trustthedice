class CreatePlayers < ActiveRecord::Migration[8.0]
  def change
    create_table :players do |t|
      t.references :team, null: false, foreign_key: true
      t.string :name, null: false
      t.boolean :is_host, default: false, null: false
      t.boolean :online, default: true, null: false

      t.timestamps
    end
  end
end
