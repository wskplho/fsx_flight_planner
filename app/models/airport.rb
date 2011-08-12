class Airport < ActiveRecord::Base
	has_many :runways
	belongs_to :country

  validates :code, :presence => true, :uniqueness => true
end
