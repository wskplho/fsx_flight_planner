require 'csv'

class AirportsCsvParser
  CSV_FILE = Rails.root.join('public', 'resources', 'airports.csv')
  RED = "\e[0;31m"
  GREEN = "\e[0;32m"
  RESET = "\e[0m"

  def initialize
    @codes = {}
  end

  def save
    unless File.exist? CSV_FILE
      puts "Cannot find #{ CSV_FILE }."
      return
    end
    CSV.foreach(CSV_FILE, :col_sep => '	') do |row|
      code, name = row[7], row[3]
      next if code.blank? or name.blank?
      @code, @name = code.strip, name.strip

      unless airport_found
        puts "#{ RED }!!! #{ @code } not found#{ RESET }"
        next
      end

      if already_saved
        puts "#{ GREEN }!!! #{ @code } #{ @name } already saved#{ RESET }"
        next
      end

      @airport.name = @name
      @airport.save
      puts "#{ @airport.code } #{ @airport.name }"
    end
  end

  def self.save_missing
    {
      '03N' => 'Utirik',
      '1Q9' => 'Mili',
      '3N0' => 'Namorik',
      '3N1' => 'Maloelap',
      'N18' => 'Tinak',
      'N20' => 'Ine',
      'N36' => 'Wotje',
      'Q51' => 'Kili',
      'Q30' => 'Mejit',
      'ZYYJ' => 'Yanji',
    }.each do |code, name|
      airport = Airport.where(:code.eq => code).first
      airport.name = name
      airport.save
      puts "#{ code } #{ name }"
    end
  end

  protected

    def airport_found
      @airport = Airport.where(:code.eq => @code).first
    end

    def already_saved
      @airport.code == @code && @airport.name == @name
    end
end