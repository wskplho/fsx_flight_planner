class Country < ActiveRecord::Base
	has_many :airports

  validates :name, :presence => true, :uniqueness => true
  attr_accessible :name
end
