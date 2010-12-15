class FactsBecomePolymorphic < ActiveRecord::Migration
  def self.up
    add_column :facts, :factable_id, :integer, :default => 0
    add_column :facts, :factable_type, :string, :limit => 15, :default => ""
    Fact.update_all("factable_type = 'Project'")
    Fact.update_all("factable_id = project_id")
    remove_column :facts, :project_id
  end

  def self.down
    add_column :facts, :project_id, :integer
    Fact.update_all("project_id = factable_id")
    remove_column :facts, :factable_id
    remove_column :facts, :factable_type
  end
end
