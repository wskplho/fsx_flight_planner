# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

%w(fsx_dat_parser csv_parser_owl).each { |file| require Rails.root.join('lib', file) }

unless Aircraft.count > 0
  aircraft = []
  aircraft << Aircraft.new({
    :name         => 'AgustaWestland EH101',
    :range        => 863,
    :cruise_speed => 150,
    :helicopter   => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Airbus A321',
    :range        => 2454,
    :cruise_speed => 447,
    :jet          => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Beechcraft Baron 58',
    :range        => 1569,
    :cruise_speed => 200,
    :propeller    => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Beechcraft King Air 350',
    :range        => 1765,
    :cruise_speed => 313,
    :propeller    => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Bell 206B JetRanger',
    :range        => 435,
    :cruise_speed => 115,
    :helicopter   => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Boeing 737-800',
    :range        => 3060,
    :cruise_speed => 477,
    :jet          => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Boeing 747-400',
    :range        => 7325,
    :cruise_speed => 491,
    :jet          => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Boeing F/A-18 Hornet',
    :range        => 1089,
    :cruise_speed => 580,
    :jet          => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Bombardier CRJ700',
    :range        => 1702,
    :cruise_speed => 515,
    :jet          => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Bombardier Learjet 45',
    :range        => 2200,
    :cruise_speed => 464,
    :jet          => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Cessna C172SP Skyhawk',
    :range        => 696,
    :cruise_speed => 122,
    :propeller    => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Cessna C208B Grand Caravan',
    :range        => 1248,
    :cruise_speed => 175,
    :propeller    => true,
  })
  aircraft << Aircraft.new({
    :name         => 'de Havilland Beaver DHC2',
    :range        => 395,
    :cruise_speed => 124,
    :propeller    => true,
    :water        => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Douglas DC-3',
    :range        => 1845,
    :cruise_speed => 161,
    :propeller    => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Grumman Goose G21A',
    :range        => 695,
    :cruise_speed => 166,
    :propeller    => true,
    :water        => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Maule Orion',
    :range        => 600,
    :cruise_speed => 142,
    :propeller    => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Mooney Bravo',
    :range        => 1050,
    :cruise_speed => 195,
    :propeller    => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Piper J-3 Cub',
    :range        => 190,
    :cruise_speed => 73,
    :propeller    => true,
  })
  aircraft << Aircraft.new({
    :name         => 'Robinson R22 Beta II',
    :range        => 200,
    :cruise_speed => 96,
    :helicopter   => true,
  })
  aircraft.each { |a| puts "Saving aircraft #{ a.name } (#{ a.save })" }
end

parser = FsxDatParser.new
parser.read_file Rails.root.join('public', 'resources', 'fs10.Airports.dat')
parser.parse_countries unless Country.count > 0
parser.parse_airports unless Airport.count > 0

CsvParserOwl.new.save
CsvParserOwl.save_missing