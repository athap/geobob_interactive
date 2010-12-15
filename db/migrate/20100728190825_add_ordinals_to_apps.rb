class AddOrdinalsToApps < ActiveRecord::Migration
  def self.up
    add_column :app_maps, :sort, :integer, :default => 0
    add_column :app_links, :sort, :integer, :default => 0
    add_column :app_feeds, :sort, :integer, :default => 0
  end

  def self.down
    remove_column :app_maps, :sort
    remove_column :app_links, :sort
    remove_column :app_feeds, :sort
  end
end
