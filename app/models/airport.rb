class Airport < ActiveRecord::Base
  include Math

  R = 6371 # km
  NAUTICAL_MILE = 1.852 # km
  RAD = Math::PI / 180

  has_many :runways
  belongs_to :country

  validates :code, :presence => true, :uniqueness => true

  def self.random( number )
    range = 1..(Airport.count - 1)
    array = range.to_a
    airports = []
    number.times { airports << where(:id.matches => array.sample).first }
    airports
  end

  def distance_to( other )
    raise "#{ other.inspect } is not an Airport!" unless other.is_a? Airport
    dLat = (other.latitude - self.latitude) * RAD
    dLong = (other.longitude - self.longitude) * RAD
    a = sin(dLat / 2) ** 2 + sin(dLong / 2) ** 2 * cos(self.latitude * RAD) * cos(other.latitude * RAD)
    c = 2 * atan2( sqrt(a), sqrt(1 - a) )
    d = (R * c / NAUTICAL_MILE).round
  end
end
