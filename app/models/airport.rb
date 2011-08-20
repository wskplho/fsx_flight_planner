class Airport < ActiveRecord::Base
  include Math

  delegate :name, :to => :country, :prefix => true

  R = 6371 # km
  NAUTICAL_MILE = 1.852 # km
  RAD = Math::PI / 180

  has_many :runways
  belongs_to :country

  before_save :fill_name_with_code

  validates :code, :presence => true, :uniqueness => true

  def distance_to( other )
    raise "#{ other.inspect } is not an Airport!" unless other.is_a? Airport
    d_lat = (other.latitude - self.latitude) * RAD
    d_long = (other.longitude - self.longitude) * RAD
    a = sin(d_lat / 2) ** 2 + sin(d_long / 2) ** 2 * cos(self.latitude * RAD) * cos(other.latitude * RAD)
    c = 2 * atan2( sqrt(a), sqrt(1 - a) )
    d = (R * c / NAUTICAL_MILE).round
  end

  def fill_name_with_code
    if self.name && self.code
      self.name_with_code = "#{ self.code } #{ self.name }"
    elsif self.name
      self.name_with_code = self.name
    elsif self.code
      self.name_with_code = self.code
    end
  end
end