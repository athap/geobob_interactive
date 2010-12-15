class AddSubtitleToFacts < ActiveRecord::Migration
  def self.up
    add_column :facts, :subtitle, :string, :default => ''
  end

  def self.down
    remove_column :facts, :subtitle
  end
end
