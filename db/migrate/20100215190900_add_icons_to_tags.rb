class AddIconsToTags < ActiveRecord::Migration
  def self.up
    add_column :tags, :icon, :string
  end

  def self.down
    remove_column :tags, :icon
  end
end
