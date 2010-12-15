class AddZoomLevelToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :zoom_level, :integer
  end

  def self.down
    remove_column :projects, :zoom_level
  end
end
