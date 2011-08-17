class Aircraft < ActiveRecord::Base
  def self.random
    order('RAND()').first
  end
end
