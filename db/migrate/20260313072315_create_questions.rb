class CreateQuestions < ActiveRecord::Migration[8.0]
  def change
    create_table :questions do |t|
      t.string :topic
      t.string :difficulty
      t.string :qtype
      t.text :prompt
      t.string :correct_answer
      t.json :aliases
      t.json :options
      t.string :source
      t.string :region

      t.timestamps
    end
  end
end
