class Question < ActiveRecord::Base
  belongs_to :fact
  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a['content'].blank? }, :allow_destroy => true
  attr_accessible :content, :answers_attributes
  
  def json_hash
    {
      :content => self.content,
      :answers => self.answers.collect{|a| a.json_hash}
    }
  end
  
end