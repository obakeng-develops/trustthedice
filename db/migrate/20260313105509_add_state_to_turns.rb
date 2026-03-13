class AddStateToTurns < ActiveRecord::Migration[8.1]
  def change
    add_column :turns, :state, :string, default: "dice_ready", null: false
    add_index :turns, :state
  end
end
