require 'csv'

class CsvParserOwl
  CSV_FILE = Rails.root.join('public', 'resources', 'owl.csv')
  RED = "\e[0;31m"
  GREEN = "\e[0;32m"
  RESET = "\e[0m"

  def initialize
    @codes = {}
    @airports = Airport.all
  end

  def save
    unless File.exist? CSV_FILE
      puts "Cannot find #{ CSV_FILE }."
      return
    end
    CSV.foreach(CSV_FILE, :col_sep => '	') do |row|
      @airport = nil
      code, name = row[7], row[3]
      next if code.blank? or name.blank?
      @code, @name = code.strip, name.strip

      if already_saved
        puts "#{ GREEN }!!! #{ @code } #{ @name } already saved#{ RESET }"
        next
      end

      unless airport_found
        puts "#{ RED }!!! #{ @code } not found#{ RESET }"
        next
      end

      if already_has_a_name
        puts "#{ GREEN }!!! #{ @airport.code } already has name#{ RESET }"
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

    def already_saved
      @airports.any? { |a| a.code == @code && a.name == @name }
    end

    def airport_found
      @airport = @airports.find { |a| a.code == @code }
    end

    def already_has_a_name
      @airport.name.present?
    end
end