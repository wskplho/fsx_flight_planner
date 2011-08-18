class AirportsController < ApplicationController
  autocomplete :aircraft, :name, :full => true
  autocomplete :airport, :name_with_code, :full => true, :extra_data => [ :code ], :limit => 20
  autocomplete :country, :name, :full => true

  def index
  end

  def select_options
    if params[:aircraft_name].present?
       @aircraft = Aircraft.where(:name.matches => params[:aircraft_name]).first
    elsif params[:aircraft_id].present?
      @aircraft = Aircraft.find params[:aircraft_id]
    end

    if params[:country_name].present?
       @country = Country.where(:name.matches => params[:country_name]).first
    elsif params[:country_id].present?
      @country = Country.find params[:country_id]
    end

    list
    render 'index'
  end

  def list
    init_airports!
    init_relation!
    init_aircraft!
    modify_relation_by_aircraft!
    set_relation_order!
    @call_count = 0
    (params[:no_of_waypoints].present? ? params[:no_of_waypoints] : 2).to_i.times { create_waypoint! }

    @total_distance = find_total_distance @first_waypoint
    t = (@total_distance.to_f / @aircraft.cruise_speed * 60 * 60).round
    mm, ss = t.divmod 60
    hh, mm = mm.divmod 60
    dd, hh = hh.divmod 24
    @eta = sprintf "%02d:%02d", hh, mm
  end

  protected

    def init_airports!
      @airports = []
    end

    def init_relation!
      @rel = Airport.joins(:runways, :country).group('`airports`.`id`')
    end

    def init_aircraft!
      @aircraft = Aircraft.order('RAND()').first unless @aircraft
    end

    def modify_relation_by_aircraft!
      @rel = @rel.where(:runways => { :length.gt => 5000, :hard.eq => true }) if @aircraft.jet
    end

    def set_relation_order!
      @rel = @rel.order('RAND()')
      @rel = @rel.where(:country_id.eq => @country.id) if @country
    end

    def create_waypoint!
      @call_count += 1
      p @call_count
      next_airport!
      unless @current_waypoint
        @current_waypoint = Waypoint.new :airport => @next_airport
        @first_waypoint = @current_waypoint
      else
        distance = @current_waypoint.airport.distance_to @next_airport
        if distance > @aircraft.range
          puts "Distance > #{ @aircraft.name } range #{ distance } > #{ @aircraft.range }, #{ @next_airport.code }"
          exclude_selected_airports!
          create_waypoint!
          return
        end
        next_waypoint = Waypoint.new :from => @current_waypoint, :airport => @next_airport, :distance => distance
        @current_waypoint.to = next_waypoint
        @current_waypoint = next_waypoint
      end
      exclude_selected_airports!
    end

    def next_airport!
      unless @airports.empty?
        @rel = @rel.where(:country_id.eq => @first_waypoint.airport.country.id) if @aircraft.range < 500
        @next_airport = @rel.where(:id.not_in => @airports.map(&:id)).first
      else
        @next_airport = @rel.first
      end
    end

    def exclude_selected_airports!
      @airports << @next_airport
    end

    def find_total_distance(waypoint)
      distance = waypoint.distance
      if next_waypoint = waypoint.to
        distance += find_total_distance(next_waypoint)
      end
      distance
    end
end
