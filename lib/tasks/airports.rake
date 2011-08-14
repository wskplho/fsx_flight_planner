%w(airport_data_com_digger airport_name_digger csv_parser_a_to_z csv_parser_all csv_parser_usa csv_parser_owl).each do |file|
  require Rails.root.join('lib', file)
end

namespace :airports do
  desc 'Fetch names for airports.'
  task :fetch_names => :environment do
    AirportNameDigger.new.start
  end

  namespace :airport_data_com do
    desc 'Save all airport code and names from airport-data.com, save to a JSON file.'
    task :save do
      AirportDataComDigger.new.save
    end

    desc 'Parse the JSON file and save names to database.'
    task :load => :environment do
      AirportDataComDigger.new.load
    end
  end

  namespace :csv do
    desc 'Parse a_to_z.csv and save names to database.'
    task :a_to_z => :environment do
      CsvParserAToZ.new.save
    end

    desc 'Parse all.csv and save names to database.'
    task :all => :environment do
      CsvParserAll.new.save
    end

    desc 'Parse usa.csv and save names to database.'
    task :usa => :environment do
      CsvParserUsa.new.save
    end

    desc 'Parse owl.csv and save names to database.'
    task :owl => :environment do
      CsvParserOwl.new.save
    end
  end

  desc 'Fill name_with_code field.'
  task :fill_name_with_code_fields => :environment do
    #Airport.update_all "name_with_code = CONCAT(name, ' ', code) WHERE name_with_code IS NULL"
    Airport.update_all "name_with_code = code WHERE name_with_code IS NULL and name IS NULL"
  end
end