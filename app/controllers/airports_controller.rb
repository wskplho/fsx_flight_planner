class AirportsController < ApplicationController
  autocomplete :airport, :name_with_code, :full => true, :extra_data => [ :code ]
  autocomplete :country, :name, :full => true

  def index
    rel = Airport.joins(:runways, :country).group('`airports`.`id`')
    @aircraft = Aircraft.order('RAND()').first
    if @aircraft.jet
      rel = rel.where(:runways => { :length.gt => 5000, :hard.eq => true })
    end
    rel = rel.order('RAND()')
    @airport1 = rel.first
    catch :done do
      rel.where(:id.not_eq => @airport1.id, :country_id.eq => @airport1.country.id).each do |airport|
        #puts "#{ airport.id }"
        if @aircraft.helicopter
          if airport.distance_to(@airport1) <= 50
            @airport2 = airport
            throw :done
          end
        else
          if airport.distance_to(@airport1) <= @aircraft.range
            @airport2 = airport
            throw :done
          end
        end
      end
    end
    @distance = @airport1.distance_to @airport2
    t = (@distance.to_f / @aircraft.cruise_speed * 60 * 60).round
    mm, ss = t.divmod 60
    hh, mm = mm.divmod 60
    dd, hh = hh.divmod 24
    @eta = "#{ hh }:#{ mm } m"
  end

  def nevim
    render 'index'
  end
end
