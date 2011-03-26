class Content < ActiveRecord::Base
  belongs_to :fact
  attr_accessible :content, :sort
  scope :by_position, :order => "position ASC, id ASC"
  before_create :set_position
  
  def set_position
    last_content = self.fact.contents.by_position.last
    if last_content
      self.position = last_content.position + 1
    else
      self.position = 1
    end
  end
  
  def json_hash
    {
      :content => self.content,
      :position => self.position
    }
  end
  
end