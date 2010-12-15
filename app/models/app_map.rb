# == Schema Information
#
# Table name: app_maps
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  google_map_feed :string(2083)
#  string          :string(2083)
#  location        :string(255)
#  zoom_level      :integer
#  lat             :decimal(15, 10)
#  lng             :decimal(15, 10)
#  icon_list       :text
#  created_at      :datetime
#  updated_at      :datetime
#

class AppMap < ActiveRecord::Base
  include LocationMethods
  include ZipMethods
  
  acts_as_mappable
  acts_as_taggable
  
  belongs_to :project
  has_many :facts, :as => :factable
  
  attr_protected :created_at, :updated_at
  
  has_attached_file :icon, 
                    :styles => { :phone => "57x57>" },
                    :default_url => "/images/author_imgs/icon_maps.png"
                    
  def read_google_map
    if self.google_map_feed
      if self.google_map_feed[0...4] == 'feed'
        # Do a little clean up if needed.
        self.google_map_feed[0...4] = 'http'
        self.save
      end
      elements = {'georss:point' => :location}
      elements.each do |key, value|
        Feedzirra::Feed.add_common_feed_entry_element(key, :as => value)
      end
      feed = Feedzirra::Feed.fetch_and_parse(self.google_map_feed)
      feed.entries.each do |entry|
        fact = self.facts.find_by_title(entry.title)
        if fact
          fact.title = entry.title.strip
          fact.content = entry.summary.strip
          fact.location = entry.location.strip
        else
          fact = self.facts.build(:title => entry.title, :content => entry.summary, :location => entry.location)
        end
        fact.set_lat_lng_from_location
        fact.save
      end
    end
  end
    
end

# Might be helpful for this object

# controller:
# if @project.location_changed?
#   @project.set_lat_lng_from_location
# end
#    @project.set_lat_lng_from_location


# form
# <%= f.text_field :google_map_feed, { :label => 'Google Map Feed',
#                                      :tip => "Add an RSS feed from a Google Map.  This will let you pull in pins from that map." } -%>
# 
# <%#= f.text_field :zoom_level, { :label => 'Google Map Zoom Level',
#                                 :tip => "This will set the default zoom level for the Google map.  The higher the number the closer the zoom.  Suggested values are between 8 and 18" } -%>
# 
# <%= f.text_field :location, { :label => 'Project Location',
#                               :tip => "<p>Set an approximate center point or general location for the project.</p>" } -%>
