class Answer < ActiveRecord::Base
  belongs_to :content
  attr_accessible :content, :correct, :correct_feedback, :incorrect_feedback
  
  def json_hash
    {
      :content => self.content,
      :correct => self.correct,
      :correct_feedback => self.correct_feedback,
      :incorrect_feedback => self.incorrect_feedback
    }
  end
  
end