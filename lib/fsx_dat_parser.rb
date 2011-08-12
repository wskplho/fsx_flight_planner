class FsxDatParser
  IGNORE_REGEX = /^(}|{|PARKING)/

  def read_file( path )
    @data = File.read path
  end

  # KDCU,34.652647153,-86.945366710,180.4,G,2,0.70,United States
  def parse_countries
    puts 'Parsing countries.'
    @data.split("\r\n").find_all { |line| line.match(/(.*,){7}(.*)/) }.map { |line| line.split(',').last }.compact.uniq.sort.each do |country|
      country = Country.new :name => country
      puts %(Cannot save #{ country.name }: "#{ country.errors }") unless country.save
    end
  end

  # Parse the FSX file, fetch airport info and runways info
  def parse_airports
    puts 'Parsing airports.'
    data = @data.split(/^\s*$/)
    size = data.size
    data.each_with_index do |airport_data, index|
      i = index + 1
      puts "#{ i } / #{ size } (#{ (i.to_f / size * 100).round } %)" if i % 500 == 0
      useful_data = get_rid_of_useless_info airport_data
      airport = Airport.new
      set_airport_info useful_data.shift, airport
      set_runways useful_data, airport
      raise "What is this: #{ useful_data.compact }? Definitely not a RUNWAY, PARKING or airport info." if useful_data.compact.present?
      puts %(Cannot save #{ airport.code }: "#{ airport.errors }") unless airport.save
    end
  end

  protected

    # Get rid of useless info
    def get_rid_of_useless_info( raw_airport_data )
      raw_airport_data.split(/\s+$/).map { |i| i.strip }.reject { |i| i.match IGNORE_REGEX }
    end

    # Fetch airport info like code, latitude, longitude, elevation and country
    # ["2VG3", "38.548611067", "-78.871111125", "411.5", "G", "0", "0.70", "United States"]
    def set_airport_info( line, airport )
      info = line.split(',')
      airport.country   = Country.where(:name.matches => info[7]).first
      airport.code      = info[0]
      airport.latitude  = info[1]
      airport.longitude = info[2]
      airport.elevation = info[3]
    end

    # Fetch runways info like runway length and material
    # ["RUNWAY", "2450", "80", "SOFT"]
    def set_runways( lines, airport )
      lines.each_with_index do |line, index|
        if line.match(/^RUNWAY/)
          info = line.split(',')
          runway = Runway.new
          runway.length    = info[1]
          runway.elevation = info[2]
          runway.hard      = info[3] == 'HARD'
          airport.runways << runway
          lines[index] = nil
        end
      end
    end
end