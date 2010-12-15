class AddFeedToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :google_map_feed, :string, :limit => 2083
  end

  def self.down
    remove_column :projects, :google_map_feed
  end
end
