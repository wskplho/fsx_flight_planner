class CreateRunways < ActiveRecord::Migration
  def self.up
    create_table :runways do |t|
      t.integer :airport_id
      t.integer :length
      t.integer :elevation
      t.boolean :hard

      t.timestamps
    end

    add_index :runways, :airport_id
  end

  def self.down
    drop_table :runways
  end
end
