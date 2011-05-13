class AddWidthHeightToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :width, :integer
    add_column :projects, :height, :integer
  end

  def self.down
    remove_column :projects, :width
    remove_column :projects, :height    
  end
end
