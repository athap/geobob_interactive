class RenameQuestionsTable < ActiveRecord::Migration
  def self.up
    drop_table :contents
    rename_table :questions, :contents
    add_column :contents, :position, :integer
    add_column :contents, :category, :string
  end

  def self.down
    rename_table :contents, :questions
  end
end
