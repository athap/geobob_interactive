class Fact < ActiveRecord::Base
  
  include AASM
  include LocationMethods
  
  validates_presence_of :title
  #validates_presence_of :location
  validates_presence_of :content
  validates_presence_of :factable
  
  belongs_to :factable, :polymorphic => true
  acts_as_mappable
  acts_as_taggable
  
  has_many :questions, :dependent => :destroy
  accepts_nested_attributes_for :questions, :reject_if => lambda { |a| a['content'].blank? }, :allow_destroy => true
  
  has_attached_file :photo, 
                    :styles => { :medium => "300x300>",
                                 :thumb => "100x100>",
                                 :icon => "50x50>",
                                 :tiny => "24x24>" },
                                 :default_url => "http://www.google.com/mapfiles/marker.png"
  
  attr_accessible :title, :subtitle, :horizontal_offset, :content, :vertical_offset, :latitude, :longitude, 
                  :pincolor, :animate, :rightButton, :mapButton, :homepage, :image, :category, :questions_attributes, :tag_list
  
  aasm_initial_state :new

  aasm_state :new
  aasm_state :approved

  aasm_event :approve do
    transitions :to => :approved, :from => [:new]
  end
  
  scope :by_position, :order => "position ASC, id ASC"
  
  before_create :set_position
  
  def add_default_questions
    1.times do
      question = self.questions.build
      4.times { question.answers.build }
    end
  end  
  
  def categories
    categories = self.tags.collect{ |tag| tag.name }
    categories = ['uncategorized'] if categories.blank?
    categories
  end
  
  def icon
    if self.photo.original_filename
      self.photo.url(:icon)
    elsif tag = self.tags.first
      tag.icon
    else
      '/images/dot.png'
      #'http://maps.google.com/mapfiles/marker.png'
    end
  end
  
  # Methods for json export
  def latitude
    self.lat
  end
  
  def longitude
    self.lng
  end
  
  def pincolor
    'red'
  end
  
  def animate
    true
  end
  
  def rightButton
    "arrow.png"
  end
  
  def mapButton
    "map.png"
  end
  
  def homepage
    "main.html?id=#{self.id}"
  end
  
  def image
    #self.photo.url(:thumb)
    "images/#{self.photo_file_name}"
  end
  
  def category
    tag = self.tags.first
    if tag
      tag.name
    else
      ''
    end
  end
  
  def set_position
    last_fact = self.factable.facts.by_position.last
    if last_fact
      self.position = last_fact.position + 1
    else
      self.position = 1
    end
  end
  
  def json_hash
    { :id => id,
      :title => title || "#{id}",
      :subtitle => subtitle,
      :content => content,
      :latitude => latitude,
      :longitude => longitude,
      :pincolor => pincolor,
      :animate => animate,
      :rightButton => rightButton,
      :mapButton => mapButton,
      :homepage => homepage,
      :image => image,
      :category => category,
      :vertical_offset => vertical_offset,
      :horizontal_offset => horizontal_offset }
  end
  
end
