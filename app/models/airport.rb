class Airport < ActiveRecord::Base
  include Math

  R = 6371 # km
  NAUTICAL_MILE = 1.852 # km
  RAD = Math::PI / 180

  has_many :runways
  belongs_to :country

  before_save :fill_name_with_code

  validates :code, :presence => true, :uniqueness => true

  def self.random
    #where(:id => (1..(count - 1)).to_a.sample).first
    order('RAND()').first
  end

  def distance_to( other )
    raise "#{ other.inspect } is not an Airport!" unless other.is_a? Airport
    dLat = (other.latitude - self.latitude) * RAD
    dLong = (other.longitude - self.longitude) * RAD
    a = sin(dLat / 2) ** 2 + sin(dLong / 2) ** 2 * cos(self.latitude * RAD) * cos(other.latitude * RAD)
    c = 2 * atan2( sqrt(a), sqrt(1 - a) )
    d = (R * c / NAUTICAL_MILE).round
  end

  def fill_name_with_code
    if self.name && self.code
      self.name_with_code = "#{ self.name } #{ self.code }"
    elsif self.name
      self.name_with_code = self.name
    elsif self.code
      self.name_with_code = self.code
    end
  end
end
