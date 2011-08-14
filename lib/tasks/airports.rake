require Rails.root.join('lib', 'airport_name_digger')

namespace :airports do
  desc 'Fetch names for airports.'
  task :fetch_names => :environment do
    AirportNameDigger.new.start
  end

  desc 'Fill name_with_code field.'
  task :fill_name_with_code_fields => :environment do
    #Airport.update_all "name_with_code = CONCAT(name, ' ', code) WHERE name_with_code IS NULL"
    Airport.update_all "name_with_code = code WHERE name_with_code IS NULL and name IS NULL"
  end
end