class Answer < ActiveRecord::Base
  belongs_to :question
  attr_accessible :content, :correct
  
  def json_hash
    {
      :content => self.content,
      :correct => self.correct,
      :correct_feedback => self.correct_feedback,
      :incorrect_feedback => self.incorrect_feedback
    }
  end
  
end