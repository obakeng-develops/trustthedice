class AddRepQuestionCountsToRounds < ActiveRecord::Migration[8.1]
  def change
    add_column :rounds, :rep_question_counts, :json, default: {}, null: false
  end
end
