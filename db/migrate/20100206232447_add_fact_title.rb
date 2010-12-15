class AddFactTitle < ActiveRecord::Migration
  def self.up
    add_column :facts, :title, :string
  end

  def self.down
    remove_column :facts, :title
  end
end
