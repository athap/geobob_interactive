class CreateFacts < ActiveRecord::Migration
  def self.up
    create_table :facts do |t|
      t.integer :project_id
      t.text :content
      t.string :location
      t.decimal :lat, :precision => 15, :scale => 10
      t.decimal :lng, :precision => 15, :scale => 10
      t.string :photo_file_name
      t.string :photo_content_type
      t.string :aasm_state
      t.integer :photo_file_size
      t.timestamps
    end
    add_index  :facts, [:lat, :lng]
  end

  def self.down
    drop_table :facts
  end
end