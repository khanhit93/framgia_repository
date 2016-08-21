class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.boolean :is_correct, default: false
      t.references :word, index: true, foreign_key: true
      t.references :word_answer, index: true, foreign_key: true
      t.references :lesson, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
