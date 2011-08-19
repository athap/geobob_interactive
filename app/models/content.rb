class Content < ActiveRecord::Base
  belongs_to :fact
  has_many :answers, :dependent => :destroy
  has_many :ispies, :dependent => :destroy

  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a['answer'].blank? }, :allow_destroy => true
  accepts_nested_attributes_for :ispies, :reject_if => proc { |attrs| attrs['position_x'].blank? || attrs['position_y'].blank? }

  attr_accessible :content, :answers_attributes, :position, :category, :ispies_attributes, :video

  scope :by_position, :order => "position ASC"
  scope :only_questions, where(:category => 'question')
  scope :only_ispies, where(:category => 'ISpy')
  #commented by Atul
  #scope :only_contents, where(:category => 'content')
  scope :only_contents, where(:category => 'narration')

  before_create :set_position, :set_category

  has_attached_file :video
                    #,:default_url => "http://www.google.com/mapfiles/marker.png"
  
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
      h[:video] = video #added by Atul
    elsif self.is_ISpy?
      h[:objects] = self.ispies.collect{|is| is.json_hash}
    end
    h
  end
  
  def is_question?
    self.category == 'question'
  end
  
  #Commented by Atul
  #def is_content?
   # self.category == 'content'
  #end
  
  # Below lines are added by Atul 
  def is_content?
    self.category == 'narration'
  end
  

  def is_ISpy?
    self.category == 'ISpy'
  end
  #commented by Atul
  #def self.categories
   # ['content', 'question']
  #end

  #below lines are added by Atul as now the category content has changed to narration
  def self.categories
    ['narration', 'question', 'ISpy']
  end
  
  def video
    "#{self.video_file_name}"
  end

  def self.fix_position
    facts = Fact.all
    facts.each do |fact|
      contents = fact.contents.by_position
      contents.each_with_index do |content, index|
        content.update_attribute(:position, index + 1)
      end
    end
  end
  
end
