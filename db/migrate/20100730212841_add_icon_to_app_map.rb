class AddIconToAppMap < ActiveRecord::Migration
  def self.up
    add_column :app_maps, :icon_file_name, :string
    add_column :app_maps, :icon_content_type, :string
    add_column :app_maps, :icon_file_size, :integer
  end

  def self.down
    remove_column :app_maps, :icon_file_name
    remove_column :app_maps, :icon_content_type
    remove_column :app_maps, :icon_file_size
  end
end
