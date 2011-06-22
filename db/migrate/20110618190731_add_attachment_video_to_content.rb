class AddAttachmentVideoToContent < ActiveRecord::Migration
  def self.up
    add_column :contents, :video_file_name, :string
    add_column :contents, :video_content_type, :string
    add_column :contents, :video_file_size, :integer
    add_column :contents, :video_updated_at, :datetime
  end

  def self.down
    remove_column :contents, :video_file_name
    remove_column :contents, :video_content_type
    remove_column :contents, :video_file_size
    remove_column :contents, :video_updated_at
  end
end
