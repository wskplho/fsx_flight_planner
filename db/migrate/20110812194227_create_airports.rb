class CreateAirports < ActiveRecord::Migration
  def self.up
    create_table :airports do |t|
      t.integer :country_id
      t.string :name
      t.string :code
      t.string :name_with_code, :string
      t.decimal :latitude, :precision => 12, :scale => 9
      t.decimal :longitude, :precision => 12, :scale => 9
      t.integer :elevation

      t.timestamps
    end

    add_index :airports, :country_id
  end

  def self.down
    drop_table :airports
  end
end
