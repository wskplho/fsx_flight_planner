class Aircraft < ActiveRecord::Base
  attr_accessible :name, :range, :cruise_speed, :helicopter, :jet, :propeller, :water
end
