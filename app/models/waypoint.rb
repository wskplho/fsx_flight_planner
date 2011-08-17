class Waypoint
  attr_accessor :from, :to, :airport, :distance

  def initialize(hash)
    self.from, self.to, self.distance = nil, nil, 0
    hash.each do |key, value|
      self.send("#{ key }=".to_sym, value)
    end
  end
end