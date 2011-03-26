class CreateContents < ActiveRecord::Migration
  def self.up
    create_table :contents do |t|
      t.integer :fact_id
      t.text :content
      t.integer :position
      t.timestamps
    end
    add_index  :contents, :fact_id
  end

  def self.down
    drop_table :contents
  end
end