class AddNameWithCodeToAirports < ActiveRecord::Migration
  def self.up
    add_column :airports, :name_with_code, :string
  end

  def self.down
    remove_column :airports, :name_with_code
  end
end
