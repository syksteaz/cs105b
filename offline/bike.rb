#Eden Zik and Ryan Marcus

TIRE_WIDTH_FACTOR = 250
FRONT_SUSPENSION_FACTOR = 100
REAR_SUSPENSION_FACTOR = 150
COMMISSION = 0.25
FRONT_SUSPENSION_PRICE = 95.0
REAR_SUSPENSION_PRICE = 67.0
BASE_PRICE = 490.00

class MountainBike  

	def initialize(owner, tire_width)	
		@owner = owner
		@tire_width = tire_width
  	end

	def owner
		@owner
	end

	def to_s
		owner = @owner
		"Mountain bike - owner: #{owner}, off road ability: #{off_road_ability()}, price: #{price}"
	end
end


class FullSuspension < MountainBike		#Extends class
	def initialize(owner, tire_width, front_fork_travel, rear_fork_travel)
		super(owner, tire_width)
		@front_fork_travel = front_fork_travel
		@rear_fork_travel = rear_fork_travel
	end

  
	def off_road_ability
    	result = @tire_width * TIRE_WIDTH_FACTOR
    	result += @front_fork_travel * FRONT_SUSPENSION_FACTOR
      	result += @rear_fork_travel * REAR_SUSPENSION_FACTOR
    	result
  	end
  
  	def price
    	(1 + COMMISSION) * BASE_PRICE + FRONT_SUSPENSION_PRICE + REAR_SUSPENSION_PRICE
  	end
end

class FrontSuspension < MountainBike
	def initialize(owner, tire_width, front_fork_travel)
		super(owner, tire_width)
		@front_fork_travel = front_fork_travel
	end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR
    result += @front_fork_travel * FRONT_SUSPENSION_FACTOR
  end
  
  
  def price
	(1 + COMMISSION) * BASE_PRICE + FRONT_SUSPENSION_PRICE		#computes price
  end
end

class Rigid < MountainBike
	def initialize(owner, tire_width)
		super
	end
	
	def price
      (1 + COMMISSION) * BASE_PRICE
    end
  
	
	def off_road_ability		#defines off road ability
    	result = @tire_width * TIRE_WIDTH_FACTOR
    	return result
    end
end

pitos_bike = Rigid.new("Pito", 2.5)
puts pitos_bike

ricks_bike = FrontSuspension.new("Rick", 2, 3)
puts ricks_bike
