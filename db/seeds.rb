# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require Rails.root.join('lib', 'fsx_dat_parser')
parser = FsxDatParser.new
parser.read_file Rails.root.join('public', 'resources', 'fs10.Airports.dat')
parser.parse_countries
parser.parse_airports