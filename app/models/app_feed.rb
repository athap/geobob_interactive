# == Schema Information
#
# Table name: app_feeds
#
#  id                :integer         not null, primary key
#  title             :string(255)
#  url               :string(2083)
#  icon_file_name    :string(255)
#  icon_content_type :string(255)
#  icon_file_size    :integer
#  created_at        :datetime
#  updated_at        :datetime
#

class AppFeed < ActiveRecord::Base
  
  belongs_to :project
  
  attr_protected :created_at, :updated_at
       
  has_attached_file :icon, 
                    :styles => { :phone => "57x57>" },
                    :default_url => "/images/author_imgs/icon_RSS.png"
                    
end