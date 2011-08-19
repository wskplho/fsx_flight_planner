class CreateAirports < ActiveRecord::Migration
  def self.up
    create_table :airports do |t|
      t.integer :country_id
      t.string :name
      t.string :code
      t.string :name_with_code
      t.decimal :latitude, :precision => 12, :scale => 9
      t.decimal :longitude, :precision => 12, :scale => 9
      t.integer :elevation

      t.timestamps
    end

    add_index :airports, :country_id

    sql = <<-SQL
      CREATE FUNCTION DISTANCE (self_lat DECIMAL(12,9), self_long DECIMAL(12,9), other_lat DECIMAL(12,9), other_long DECIMAL(12,9)) RETURNS INT DETERMINISTIC
      BEGIN
        DECLARE rad DECIMAL(19,18);
        DECLARE r, d INT;
        DECLARE nautical_mile DECIMAL(4,3);
        DECLARE d_lat, d_long, a, c DECIMAL(20,18);

        SET rad = PI() / 180;
        SET r = 6371;
        SET nautical_mile = 1.852;

        SET d_lat = (other_lat - self_lat) * rad;
        SET d_long = (other_long - self_long) * rad;
        SET a = POW( SIN(d_lat / 2), 2 ) + POW( SIN(d_long / 2), 2) * COS(self_lat * rad) * COS(other_lat * rad);
        SET c = 2 * ATAN2( SQRT(a), SQRT(1 - a) );
        SET d = r * c / nautical_mile;

        RETURN d;
      END
    SQL
    ActiveRecord::Base.connection.execute sql
  end

  def self.down
    drop_table :airports
    ActiveRecord::Base.connection.execute "DROP FUNCTION DISTANCE"
  end
end
