class CreateIspies < ActiveRecord::Migration
  def self.up
    create_table :ispies do |t|
      t.float :position_x
      t.float :position_y
      t.float :trigger_x
      t.float :trigger_y
      t.float :checker_x
      t.float :checker_y
      t.float :checker_size

      t.timestamps
    end
  end

  def self.down
    drop_table :ispies
  end
end
