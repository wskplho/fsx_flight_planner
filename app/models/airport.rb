class Airport < ActiveRecord::Base
	has_many :runways
	belongs_to :country
end
