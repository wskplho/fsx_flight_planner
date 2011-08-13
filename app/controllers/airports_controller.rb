class AirportsController < ApplicationController
  autocomplete :airport, :code

  def index
  end

  def two_airports
    code1 = params[:codes][:code1]
    code2 = params[:codes][:code2]
    @airport1 = Airport.where(:code.matches => code1).first
    @airport2 = Airport.where(:code.matches => code2).first
    render 'index'
  end

  def nevim
    render 'index'
  end
end
