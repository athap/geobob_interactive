class AddContentToAnswers < ActiveRecord::Migration
  def self.up
    rename_column :answers, :question_id, :content_id
  end

  def self.down
    rename_column :answers, :content_id, :question_id
  end
end
