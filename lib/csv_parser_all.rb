require 'csv'

class CsvParserAll
  CSV_FILE = Rails.root.join('public', 'resources', 'all.csv')

  def initialize
    @codes = {}
  end

  def save
    unless File.exist? CSV_FILE
      puts "Cannot find #{ CSV_FILE }."
      return
    end
    CSV.foreach(CSV_FILE, :col_sep => ';') do |row|
      code, name = row[0], row[4]
      next if code.blank? or name.blank?
      code = code.strip
      name = name.strip
      airport = Airport.where(:code.eq => code).first
      if airport.nil?
        puts "#{ code } not found"
        next
      end
      if airport.name.present?
        puts "#{ airport.code } already has name"
        next
      end
      airport.name = name
      puts "#{ airport.code }: #{ airport.name } (#{ airport.save })"
    end
  end
end