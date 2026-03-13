class CreateBuzzs < ActiveRecord::Migration[8.0]
  def change
    create_table :buzzs do |t|
      t.references :turn, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
