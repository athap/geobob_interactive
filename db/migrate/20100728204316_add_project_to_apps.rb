class AddProjectToApps < ActiveRecord::Migration
  def self.up
    add_column :app_maps, :project_id, :integer
    add_column :app_links, :project_id, :integer
    add_column :app_feeds, :project_id, :integer
  end

  def self.down
    remove_column :app_maps, :project_id
    remove_column :app_links, :project_id
    remove_column :app_feeds, :project_id
  end
end