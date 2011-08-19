class AddContentToIspies < ActiveRecord::Migration
  def self.up
    add_column :ispies, :content_id, :int
  end

  def self.down
    remove_column :ispies, :content_id
  end
end
