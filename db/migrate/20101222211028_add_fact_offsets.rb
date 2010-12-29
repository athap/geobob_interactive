class AddFactOffsets < ActiveRecord::Migration
  def self.up
    add_column :facts, :vertical_offset, :integer
    add_column :facts, :horizontal_offset, :integer
  end

  def self.down
    remove_column :facts, :vertical_offset
    remove_column :facts, :horizontal_offset
  end
  
end
