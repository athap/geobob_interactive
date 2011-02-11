class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.integer :fact_id
      t.text :content
      t.timestamps
    end
    add_index :questions, [:fact_id]
  end

  def self.down
    drop_table :questions
  end
end
