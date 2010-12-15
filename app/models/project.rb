# == Schema Information
#
# Table name: projects
#
#  id                 :integer         not null, primary key
#  project_type_id    :integer
#  name               :string(255)
#  description        :text
#  deadline           :datetime
#  aasm_state         :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  comment_count      :integer         default(0)
#  created_at         :datetime
#  updated_at         :datetime
#  app_items          :text
#

require 'zip/zip'
require 'zip/zipfilesystem'
class Project < ActiveRecord::Base
  
  include AASM
  include ZipMethods
  
  belongs_to :project_type
  has_many :project_roles
  has_many :users, :through => :project_roles
  has_many :facts, :as => :factable
  has_many :app_maps
  has_many :app_links
  has_many :app_feeds
  
  acts_as_mappable
  acts_as_taggable
  has_friendly_id :name, :use_slug => true
  
  validates_presence_of :name
  validates_presence_of :description
  
  attr_protected :created_at, :updated_at
  
  has_attached_file :photo, 
                    :styles => { :medium => "300x300>",
                                 :thumb => "100x100>",
                                 :icon => "50x50>",
                                 :tiny => "24x24>" },
                    :default_url => "/images/project_default.jpg"
                
  has_attached_file :app_icon, 
                    :styles => { :medium => "300x300>",
                                 :thumb => "100x100>",
                                 :icon => "50x50>",
                                 :tiny => "24x24>" },
                    :default_url => "/images/project_default.jpg"
                    
  has_attached_file :splash_image, 
                    :styles => { :phone => "320x480",
                                 :background => "276x400" },
                    :default_url => "/images/project_default.jpg"
                    
  has_attached_file :background_image, 
                    :styles => { :phone => "320x480",
                                 :background => "276x400" },
                    :default_url => "/images/background_default.jpg"
                    
  aasm_initial_state :new
  
  aasm_state :new
  aasm_state :suggested
  aasm_state :finished

  aasm_event :finish do
    transitions :to => :finished, :from => [:new]
  end
    
  named_scope :by_name, :order => "name ASC"
  named_scope :recent, lambda { { :conditions => ['created_at > ?', 1.week.ago] } }
  named_scope :newest, :order => "created_at DESC"
  
  before_save :sanitize_attributes

  # Set this value to a specific user to customize the santize level for that user
  attr_accessor :current_editor
  
  def can_edit?(user)
    return true if user.admin?
    self.users.include?(user)
  end
  
  # Sanitize content before saving.  This prevent XSS attacks and other malicious html.
  def sanitize_attributes
    if self.sanitize_level
      self.description = Sanitize.clean(self.description, self.sanitize_level)
      self.name = Sanitize.clean(self.name, self.sanitize_level)
    end
  end
  
  # Override this method to control sanitization levels.
  # Currently a user who is an admin will not have their content sanitized.  A user
  # in any role 'editor', 'manager', or 'contributor' will be given the 'RELAXED' settings
  # while all other users will get 'BASIC'.
  #
  # Options are from sanitze:
  # nil - no sanitize
  # Sanitize::Config::RELAXED
  # Sanitize::Config::BASIC
  # Sanitize::Config::RESTRICTED
  # for more details see: http://rgrove.github.com/sanitize/
  def sanitize_level
    return Sanitize::Config::BASIC if self.current_editor.nil?
    return nil if self.current_editor.admin?
    return Sanitize::Config::RELAXED if self.current_editor.any_role?('editor', 'manager', 'contributor')
    Sanitize::Config::BASIC
  end

  # Generate a zip file containing all relevant files from the project
  # Code helps from:
  # http://rubyzip.sourceforge.net/
  # http://info.michael-simons.eu/2008/01/21/using-rubyzip-to-create-zip-files-on-the-fly/
  # http://74.125.155.132/search?q=cache:m4XaoZ1tRasJ:www.superwick.com/archives/2007/06/14/generating-zip-file-archives-via-ruby-on-rails/+ruby+on+rails+Tempfile+zip&cd=1&hl=en&ct=clnk&gl=us
  # http://railstalk.com/2009/8/6/create-a-zip-file-using-ruby
  def zip(path)
    FileUtils.mkdir_p(path)
    zip_file_path = File.join(path, "#{self.to_param}.zip")
    if File.exists?(zip_file_path)
      File.delete(zip_file_path)
    end
    
    # open or create the zip file
    Zip::ZipFile.open(zip_file_path, Zip::ZipFile::CREATE) do |zip_file|
      
      # Add data files
      facts_for_zip(zip_file, 'annotations.js')
      tags_for_zip(zip_file, 'category.js')

      app_maps.each do |map|
        map.facts_for_zip(zip_file, "map_#{map.id}_annotations.js")
        map.tags_for_zip(zip_file, "map_#{map.id}_category.js")
      end
      
      # Add images
      images_dir = 'images'
      zip_file.mkdir(images_dir) unless zip_file.find_entry(images_dir)
      self.facts.collect do |fact|
#        begin
          zip_file.add(fact.image, fact.photo.path(:thumb)) unless fact.photo_file_name.nil? || zip_file.find_entry(fact.image)
        # rescue => ex
        #   # Need a way to output these errors
        # end
      end
      
    end
    File.chmod(0644, zip_file_path)
    zip_file_path
  end

end
