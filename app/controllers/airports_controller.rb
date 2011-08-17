class AirportsController < ApplicationController
  autocomplete :airport, :name_with_code, :full => true, :extra_data => [ :code ], :limit => 20
  autocomplete :country, :name, :full => true

  def index
    
  end

  def select_options
    @aircraft = Aircraft.find(params[:aircraft]) if params[:aircraft].present?
    @country = Country.find(params[:country]) if params[:country].present?
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
    5.times { create_waypoint! }

    puts '========================='
    p @airports.map(&:code)
    puts '========================='

    # #rel.where(:id.not_eq => @airport1.id, :country_id.eq => @airport1.country.id).each do |airport|
    # rel.where(:id.not_eq => @airport1.id).each do |airport|
    #   #puts "#{ airport.id }"
    #   if @aircraft.helicopter
    #     if airport.distance_to(@airport1) <= 50
    #       @airport2 = airport
    #       break
    #     end
    #   else
    #     if airport.distance_to(@airport1) <= @aircraft.range
    #       @airport2 = airport
    #       break
    #     end
    #   end
    # end
    # 
    # @distance = @airport1.distance_to @airport2
    # t = (@distance.to_f / @aircraft.cruise_speed * 60 * 60).round
    # mm, ss = t.divmod 60
    # hh, mm = mm.divmod 60
    # dd, hh = hh.divmod 24
    # @eta = "#{ hh }:#{ mm } m"
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
      #@rel = @rel.where(:country_id.eq => 69)
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
      @next_airport = @rel.first
    end

    def exclude_selected_airports!
      @airports << @next_airport
      @rel = @rel.where(:id.not_in => @airports.map(&:id)) unless @airports.empty?
    end
end
