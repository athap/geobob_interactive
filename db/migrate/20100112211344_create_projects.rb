class CreateProjects < ActiveRecord::Migration
  def self.up
    
    create_table :projects do |t|
      t.integer :project_type_id
      t.string :name
      t.text :description
      t.datetime :deadline
      t.string :aasm_state
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.integer :comment_count, :default => 0
      t.string :location
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.timestamps
    end
    add_index  :projects, [:lat, :lng]
    
    create_table :project_types do |t|
      t.string :name
      t.timestamps
    end
    
    create_table :project_roles do |t|
      t.integer :user_id
      t.integer :project_id
      t.string :role
      t.timestamps
    end
    add_index  :project_roles, [:user_id, :project_id]
    
  end

  def self.down
    drop_table :projects
    drop_table :project_types
    drop_table :project_roles
  end
  
end
