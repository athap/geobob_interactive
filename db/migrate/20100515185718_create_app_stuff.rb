class CreateAppStuff < ActiveRecord::Migration
  
  def self.up
    
    create_table  :app_links, :force => true do |t|
      t.string      :title
      t.string      :url, :limit => 2083
      t.string      :icon_file_name
      t.string      :icon_content_type
      t.integer     :icon_file_size
      t.timestamps
    end
  
    create_table :app_feeds, :force => true do |t|
      t.string      :title
      t.string      :url, :limit => 2083
      t.string      :icon_file_name
      t.string      :icon_content_type
      t.integer     :icon_file_size
      t.timestamps
    end
    
    create_table :app_maps, :force => true do |t|
      t.string      :title
      t.string      :google_map_feed, :string, :limit => 2083
      t.string      :location
      t.integer     :zoom_level
      t.decimal     :lat, :precision => 15, :scale => 10
      t.decimal     :lng, :precision => 15, :scale => 10
      t.text        :icon_list
      t.timestamps
    end
    
    remove_column :projects, :location
    remove_column :projects, :lat
    remove_column :projects, :lng
    remove_column :projects, :google_map_feed
    remove_column :projects, :zoom_level
    
    add_column :projects, :app_items, :text
    
  end

  def self.down
    drop_table :app_links
    drop_table :app_feeds
    drop_table :app_maps
    
    add_column :projects, :location, :string
    add_column :projects, :lat, :decimal, :precision => 15, :scale => 10
    add_column :projects, :lng, :decimal, :precision => 15, :scale => 10
    add_column :projects, :google_map_feed, :limit => 2083
    add_column :projects, :zoom_level, :integer
    
    remove_column :projects, :app_items
  end
  
end
