class AddViewsToProjectLayout < ActiveRecord::Migration
  def self.up
    add_column :project_layouts, :view, :string
  end

  def self.down
    remove_column :project_layouts, :view
  end
end
