class AirportNameDigger
  GOOGLE_UA_STRING = 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)'

  def initialize
    @agent = Mechanize.new
    @agent.user_agent = GOOGLE_UA_STRING
  end

  def start
    last = Airport.where(:name.not_eq => nil).order(:id).last
    start = last ? last.id + 1 : nil
    Airport.where(:name => nil).find_each(:batch_size => 10, :start => start) do |airport|
      uri = URI.parse slug(airport.code)
      print "#{ uri.to_s } "
      name = @agent.get(uri).title.split('-').last.strip
      name = nil if name == 'AirNav: Airport Information'
      print name
      airport.name = name
      airport.save
      print 'ERROR' unless name
      puts
      time = (1..11).to_a.sample + 5
      puts "Sleeping #{ time }"
      sleep time
    end
  end

  def slug( code )
    "http://www.airnav.com/airport/#{ code }"
  end
end