class Flight < ActiveRecord::Base
  attr_accessor :aircraft_set, :country_set, :start_set, :finish_set, :first_waypoint, :total_distance, :eta, :cannot_find_next_waypoint
  attr_writer :aircraft, :country, :start, :finish

  def start_code=(value)
    write_attribute :start_code, value.upcase
  end

  def finish_code=(value)
    write_attribute :finish_code, value.upcase
  end

  def aircraft
    if !aircraft_set && (aircraft_name.present? || aircraft_id.present?)
      self.aircraft = Aircraft.where(:name.eq % self.aircraft_name | :id.eq % self.aircraft_id).first
      self.aircraft_set = true
    end
    @aircraft
  end

  def country
    if !country_set && (country_name.present? || country_id.present?)
      self.country = Country.where(:name.eq % self.country_name | :id.eq % self.country_id).first
      self.country_set = true
    end
    @country
  end

  def start
    if !start_set && start_code.present?
      self.start = Airport.where(:code => self.start_code).first
      self.start_set = true
    end
    @start
  end

  def finish
    if !finish_set && finish_code.present?
      self.finish = Airport.where(:code => self.finish_code).first
      self.finish_set = true
    end
    @finish
  end

  def no_of_waypoints=(value)
    value = value.to_i
    current_value = read_attribute :no_of_waypoints
    if !current_value || current_value < 2 || !value || value < 2
      write_attribute :no_of_waypoints, 2
    else
      write_attribute :no_of_waypoints, value
    end
  end

  def make_plan
    @counter = 0
    @airports = []

    self.aircraft = Aircraft.random unless aircraft
    if country
      self.start = Airport.where(:country_id => country.id).random unless start
      self.finish = Airport.where(:country_id => country.id).random unless finish
    else
      self.start = Airport.random unless start
      self.finish = Airport.random unless finish
    end

    write_attribute :aircraft_id, aircraft.id
    write_attribute :start_code, start.code
    write_attribute :finish_code, finish.code

    @rel = Airport.joins(:runways).includes(:country).group('`airports`.`id`')
    @rel = @rel.where(:runways => { :length.gt => 5000, :hard.eq => true }) if aircraft.jet
    @rel = @rel.where(:country_id.eq => country.id) if country

    spread_waypoints
    create_waypoints

    self.total_distance = find_total_distance @first_waypoint
    t = (total_distance.to_f / aircraft.cruise_speed * 60 * 60).round
    mm, ss = t.divmod 60
    hh, mm = mm.divmod 60
    dd, hh = hh.divmod 24
    self.eta = sprintf "%02d:%02d", hh, mm
  end

  protected

    # Make sure there are enough waypoints in regard to aircraft's range.
    def spread_waypoints
      distance = start.distance_to finish
      estimated_waypoints = (distance / aircraft.range) + 2
      self.no_of_waypoints = estimated_waypoints if estimated_waypoints > self.no_of_waypoints
    end

    # Recursively create waypoints along the way, narrowing the GPS distance each time.
    def create_waypoints
      @counter += 1
      next_airport
      return if cannot_find_next_waypoint
      unless @current_waypoint
        @current_waypoint = Waypoint.new :airport => @next_airport
        @first_waypoint = @current_waypoint
      else
        distance = @current_waypoint.airport.distance_to @next_airport
        self.no_of_waypoints += 1 if @counter == no_of_waypoints && distance_to_finish > aircraft.range
        next_waypoint = Waypoint.new :from => @current_waypoint, :airport => @next_airport, :distance => distance
        @current_waypoint.to = next_waypoint
        @current_waypoint = next_waypoint
      end
      exclude_visited_airports
      create_waypoints if @counter < self.no_of_waypoints
    end

    # Set a next airport we should check. This selects airports within the aircraft's range.
    def next_airport
      if distance_to_finish && distance_to_finish < aircraft.range
        @next_airport = finish
      elsif @airports.present?
        @next_airport = @rel.where(
          :id.not_in => @airports.map(&:id),
          :latitude => latitude_range,
          :longitude => longitude_range
        ).where(
          "DISTANCE(?, ?, `airports`.latitude, `airports`.longitude) < ?",
          @current_waypoint.airport.latitude,
          @current_waypoint.airport.longitude,
          @aircraft.range
        ).random
      else
        @next_airport = start
      end
      self.cannot_find_next_waypoint = true unless @next_airport
    end

    def distance_to_finish
      return unless @current_waypoint
      @current_waypoint.airport.distance_to finish
    end

    # Find delta latitude, it is a square between start and finish.
    def latitude_range(airport = nil)
      airport = @current_waypoint.airport unless airport
      min, max = min_max airport.latitude, @finish.latitude
      (min - 1)..(max + 1)
    end

    # Find delta longitude, it is a square between start and finish.
    def longitude_range(airport = nil)
      airport = @current_waypoint.airport unless airport
      min, max = min_max airport.longitude, @finish.longitude
      (min - 1)..(max + 1)
    end

    def min_max(value1, value2)
      value1 < value2 ? [ value1, value2 ] : [ value2, value1 ]
    end

    # Make sure we don't select the same airport again.
    def exclude_visited_airports
      @airports << @next_airport
    end

    # Recursively finds total distance, waypoints aren't simple array, they are linked list.
    def find_total_distance(waypoint)
      return unless waypoint
      distance = waypoint.distance
      if next_waypoint = waypoint.to
        distance += find_total_distance(next_waypoint)
      end
      distance
    end
end
