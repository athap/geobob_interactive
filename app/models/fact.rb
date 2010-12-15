# == Schema Information
#
# Table name: facts
#
#  id                 :integer         not null, primary key
#  project_id         :integer
#  content            :text
#  location           :string(255)
#  lat                :decimal(15, 10)
#  lng                :decimal(15, 10)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  aasm_state         :string(255)
#  photo_file_size    :integer
#  created_at         :datetime
#  updated_at         :datetime
#  title              :string(255)
#  subtitle           :string(255)     default("")
#

class Fact < ActiveRecord::Base
  
  include AASM
  include LocationMethods
  
  validates_presence_of :title
  validates_presence_of :location
  validates_presence_of :content
  validates_presence_of :project_id
  
  belongs_to :factable, :polymorphic => true
  acts_as_mappable
  acts_as_taggable
  has_attached_file :photo, 
                    :styles => { :medium => "300x300>",
                                 :thumb => "100x100>",
                                 :icon => "50x50>",
                                 :tiny => "24x24>" },
                                 :default_url => "http://www.google.com/mapfiles/marker.png"
  
  aasm_initial_state :new

  aasm_state :new
  aasm_state :approved

  aasm_event :approve do
    transitions :to => :approved, :from => [:new]
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
      'http://maps.google.com/mapfiles/marker.png'
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
      :category => category }
  end
  
end
