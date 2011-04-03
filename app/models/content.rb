class Content < ActiveRecord::Base
  belongs_to :fact
  has_many :answers, :dependent => :destroy
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a['content'].blank? }, :allow_destroy => true
  attr_accessible :content, :answers_attributes, :position, :category
  scope :by_position, :order => "position ASC, id ASC"
  scope :only_questions, :where => "category == 'question'"
  scope :only_contents, :where => "category == 'content'"
  
  before_create :set_position, :set_category
  
  def set_position
    last_content = self.fact.contents.by_position.last
    if last_content
      self.position = last_content.position + 1
    else
      self.position = 1
    end
  end
  
  def set_category
    self.category = 'category' if !self.category
  end
  
  def json_hash
    h = {
      :content => self.content,
      :position => self.position,
    }
    if self.is_question?
      h[:answers] = self.answers.collect{|a| a.json_hash}
    end
  end
  
  def is_question?
    self.category == 'question'
  end
  
  def is_content?
    self.category == 'content'
  end
  
  def self.categories
    ['content', 'question']
  end
  
end