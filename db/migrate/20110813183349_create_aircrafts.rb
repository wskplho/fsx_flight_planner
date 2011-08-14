class CreateAircrafts < ActiveRecord::Migration
  def self.up
    create_table :aircrafts do |t|
      t.string :name
      t.integer :range
      t.integer :cruise_speed
      t.boolean :jet,        :default => false
      t.boolean :propeller,  :default => false
      t.boolean :helicopter, :default => false
      t.boolean :water,      :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :aircrafts
  end
end
