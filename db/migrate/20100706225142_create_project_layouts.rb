class CreateProjectLayouts < ActiveRecord::Migration
  def self.up
    create_table :project_layouts, :force => true do |t|
      t.string :name
      t.integer :sort
      t.timestamps
    end
    add_column :projects, :project_layout_id, :integer
  end

  def self.down
    drop_table :project_layouts
    remove_column :projects, :project_layout_id
  end
end