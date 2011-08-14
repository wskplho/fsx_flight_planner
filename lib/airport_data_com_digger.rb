class AirportDataComDigger
  GOOGLE_UA_STRING = 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'
  LETTERS = 'A'..'Z'
  CODE_NAME_FILE = Rails.root.join('public', 'resources', 'code_name.json')

  def initialize
    @agent = Mechanize.new
    @agent.user_agent = GOOGLE_UA_STRING
    @codes = {}
  end

  def save
    LETTERS.each do |letter|
      uri = URI.parse slug(letter)
      puts "#{ uri.to_s }"
      page = @agent.get uri
      page.search('#tbl_airports tr').each do |tr|
        tds = tr.search('td')
        next if tds.empty?
        @codes[ tds[0].text.strip.to_sym ] = tds[2].text.strip
      end
      sleep 3
    end
    File.open( CODE_NAME_FILE, 'w' ).write JSON.dump(@codes)
  end

  def load
    unless File.exist? CODE_NAME_FILE
      puts "Cannot find #{ CODE_NAME_FILE }, please run rake airports:airport_data_com:save_to_file taks first."
      return
    end
    codes = JSON.parse File.read(CODE_NAME_FILE)
    codes.each do |code, name|
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

  def slug( letter )
    "http://www.airport-data.com/world-airports/icao-code/#{ letter }.html"
  end
end