class AddPositionToFacts < ActiveRecord::Migration
  def self.up
    add_column :facts, :position, :integer, :default => 0
  end

  def self.down
    remove_column :facts, :position
  end
end
