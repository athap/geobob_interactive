class AddContentToAnswers < ActiveRecord::Migration
  def self.up
    rename_column :answers, :question_id, :content_id
    rename_column :answers, :content, :answer
  end

  def self.down
    rename_column :answers, :content_id, :question_id
    rename_column :answers, :answer, :content
  end
end
