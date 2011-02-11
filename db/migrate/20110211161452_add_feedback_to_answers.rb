class AddFeedbackToAnswers < ActiveRecord::Migration
  def self.up
    add_column :answers, :correct_feedback, :string
    add_column :answers, :incorrect_feedback, :string
  end

  def self.down
    remove_column :answers, :correct_feedback
    remove_column :answers, :incorrect_feedback
  end
end
