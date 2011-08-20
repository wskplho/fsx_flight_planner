class CreateFlights < ActiveRecord::Migration
  def self.up
    create_table :flights do |t|
      t.string :aircraft_name
      t.integer :aircraft_id
      t.string :country_name
      t.integer :country_id
      t.string :start_code
      t.string :finish_code
      t.integer :no_of_waypoints, :default => 2

      t.timestamps
    end
  end

  def self.down
    drop_table :flights
  end
end
