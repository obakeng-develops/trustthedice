class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :status, default: "lobby", null: false
      t.string :host_token, null: false
      t.json :settings, default: {}

      t.timestamps
    end

    add_index :games, :host_token, unique: true
  end
end
