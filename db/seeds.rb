# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
# Setup initial user so we can get in
if !User.find_by_email('admin@example.com')
  user = User.create! :name => 'Admin', :email => 'admin@example.com', :password => 'asdfasdf', :password_confirmation => 'asdfasdf'
  user.confirmed_at = user.confirmation_sent_at
  user.save
  Role.create! :name => 'Admin'
  Role.create! :name => 'Member'

  user1 = User.find_by_email('admin@example.com')
  user1.role_ids = [1,2]
  user1.save
end

# Setup tags and related icons
tags = ([ { :name => 'historical',                    :icon => "http://google-maps-icons.googlecode.com/files/historicalquarter.png" },
          { :name => 'museum',                        :icon => "http://google-maps-icons.googlecode.com/files/museum-historical.png" }, 
          { :name => 'restaurant',                    :icon => "http://google-maps-icons.googlecode.com/files/restaurant.png" },
          { :name => 'gourmet restaurant',            :icon => "http://google-maps-icons.googlecode.com/files/restaurantgourmet.png" },
          { :name => 'fast food',                     :icon => "http://google-maps-icons.googlecode.com/files/fastfood.png" },
          { :name => 'fancy food',                    :icon => "http://google-maps-icons.googlecode.com/files/gourmet.png" },
          { :name => 'scenic view',                   :icon => "http://google-maps-icons.googlecode.com/files/beautiful.png" },
          { :name => 'panoramic view',                :icon => "http://google-maps-icons.googlecode.com/files/panoramic180.png" },
          { :name => 'point of interest',             :icon => "http://google-maps-icons.googlecode.com/files/sight.png" },
          { :name => 'geological point of interest',  :icon => "http://google-maps-icons.googlecode.com/files/glacier.png" },
          { :name => 'souvenirs',                     :icon => "http://google-maps-icons.googlecode.com/files/gifts.png" },
          { :name => 'urban park',                    :icon => "http://google-maps-icons.googlecode.com/files/park-urban.png" },
          { :name => 'park',                          :icon => "http://google-maps-icons.googlecode.com/files/park.png" },
          { :name => 'archeological',                 :icon => "http://google-maps-icons.googlecode.com/files/museum-archeological.png" },
          { :name => 'museum (art)',                  :icon => "http://google-maps-icons.googlecode.com/files/museum-art.png" },
          { :name => 'museum (historical)',           :icon => "http://google-maps-icons.googlecode.com/files/museum-historical.png" },
          { :name => 'bus',                           :icon => "http://google-maps-icons.googlecode.com/files/bus.png" },
          { :name => 'railway',                       :icon => "http://google-maps-icons.googlecode.com/files/train.png" },
          { :name => 'subway',                        :icon => "http://google-maps-icons.googlecode.com/files/subway.png" },
        ])
tags.each do |tag|
  # Tag model has attr_accessible :name set. Make other attributes available for adding/updating in this task
  tags.first.keys.each do |key|
    ActsAsTaggableOn::Tag.send(:attr_accessible, key) unless key == :name
  end
  if existing_tag = ActsAsTaggableOn::Tag.find_by_name(tag[:name])
    puts "Updating #{tag[:name]}"
    existing_tag.update_attributes!(tag)
  else
    puts "Adding #{tag[:name]}"
    ActsAsTaggableOn::Tag.create(tag)
  end
end

project_layouts = ([
    { :name => '1. List View Layout', :sort => 1 }, 
    { :name => '2. Icon Grid Layout', :sort => 2 },
    { :name => '3. Cover Flow Layout', :sort => 3 }
  ])
  
project_layouts.each do |layout|
  project_layout = ProjectLayout.find_by_name(layout[:name])
  if project_layout
    puts "Updating #{layout[:name]}"
    project_layout.update_attributes!(layout)
  else
    puts "Adding #{layout[:name]}"
    project_layout = ProjectLayout.create!(layout) # Create isn't working. It leaves name and sort nil
    project_layout.name = layout[:name]
    project_layout.sort = layout[:sort]
    project_layout.save!
  end
end