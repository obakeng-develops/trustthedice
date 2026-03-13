class RenameBuzzsToBuzzes < ActiveRecord::Migration[8.0]
  def change
    rename_table :buzzs, :buzzes
  end
end
