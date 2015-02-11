class MountainBike

  TIRE_WIDTH_FACTOR = 250
  FRONT_SUSPENSION_FACTOR = 100
  REAR_SUSPENSION_FACTOR = 150

  def initialize(params)
    params.each { |key, value| instance_variable_set "@#{key}", value }
    
    @commission = 0.25
    @front_suspension_price = 95.0
    @rear_suspension_price = 67.0
    @base_price = 490.00
  end

  def off_road_ability
    result = @tire_width * TIRE_WIDTH_FACTOR
    if @type_code == :front_suspension || @type_code == :full_suspension
      result += @front_fork_travel * FRONT_SUSPENSION_FACTOR
    end
    if @type_code == :full_suspension
      result += @rear_fork_travel * REAR_SUSPENSION_FACTOR
    end
    result
  end
  def price
    case @type_code
    when :rigid
      (1 + @commission) * @base_price
    when :front_suspension
      (1 + @commission) * @base_price + @front_suspension_price
    when :full_suspension
      (1 + @commission) * @base_price + @front_suspension_price +
        @rear_suspension_price
    end
  end

  def owner
    @owner
  end

  def to_s
    "Mountain bike - owner: #{owner}, off road ability: #{off_road_ability()}, price: #{price}"
  end

end

pitos_bike = MountainBike.new(:owner => "Pito", :type_code => :rigid, :tire_width => 2.5)
puts pitos_bike

ricks_bike = MountainBike.new(:owner => "Rick", :type_code => :front_suspension, :tire_width => 2, :front_fork_travel => 3)
puts ricks_bike




