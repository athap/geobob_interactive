class AddProjectIconFields < ActiveRecord::Migration
  def self.up
    add_column :projects, :app_icon_file_name, :string
    add_column :projects, :app_icon_content_type, :string
    add_column :projects, :app_icon_file_size, :string
    
    add_column :projects, :splash_image_file_name, :string
    add_column :projects, :splash_image_content_type, :string
    add_column :projects, :splash_image_file_size, :string
    
    add_column :projects, :background_image_file_name, :string
    add_column :projects, :background_image_content_type, :string
    add_column :projects, :background_image_file_size, :string
  end

  def self.down
    remove_column :projects, :app_icon_file_name
    remove_column :projects, :app_icon_content_type
    remove_column :projects, :app_icon_file_size
    
    remove_column :projects, :splash_image_file_name
    remove_column :projects, :splash_image_content_type
    remove_column :projects, :splash_image_file_size
    
    remove_column :projects, :background_image_file_name
    remove_column :projects, :background_image_content_type
    remove_column :projects, :background_image_file_size
  end
end
