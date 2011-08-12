class CreateAirports < ActiveRecord::Migration
  def self.up
    create_table :airports do |t|
      t.integer :id_country
      t.string :name
      t.string :code
      t.float :latitude
      t.float :longitude
      t.integer :elevation

      t.timestamps
    end

    add_index :airports, :id_country
  end

  def self.down
    drop_table :airports
  end
end
