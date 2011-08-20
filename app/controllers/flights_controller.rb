class FlightsController < ApplicationController
  autocomplete :aircraft, :name, :full => true
  autocomplete :airport, :name_with_code, :full => true, :extra_data => [ :code ], :limit => 20
  autocomplete :country, :name, :full => true

  def new
    @flight = Flight.new
  end

  def create
    @flight = Flight.new params[:flight]
    @flight.make_plan
    flash.now[:alert] = t('my.flights.cannot_find_next_waypoint', :airport => @flight.finish.name_with_code, :country => @flight.finish.country.name) if @flight.cannot_find_next_waypoint
  end
end
