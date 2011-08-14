class Aircraft < ActiveRecord::Base
  def self.random
    #where(:id => (1..(count - 1)).to_a.sample).first
    order('RAND()').first
  end
end
