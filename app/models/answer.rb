class Answer < ActiveRecord::Base
  belongs_to :content
  attr_accessible :answer, :correct, :correct_feedback, :incorrect_feedback
  
  def json_hash
    {
      :answer => self.answer,
      :correct => self.correct,
      :correct_feedback => self.correct_feedback,
      :incorrect_feedback => self.incorrect_feedback
    }
  end
  
end