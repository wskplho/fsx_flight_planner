class CreateRunways < ActiveRecord::Migration
  def self.up
    create_table :runways do |t|
      t.integer :id_airport
      t.integer :length
      t.integer :elevation
      t.boolean :hard

      t.timestamps
    end

    add_index :runways, :id_airport
  end

  def self.down
    drop_table :runways
  end
end
