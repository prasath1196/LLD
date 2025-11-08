class ParkingSlot

  attr_reader :type, :id
  attr_accessor :vehicle
  def initialize(type,id)
    @type = type
    @id = id
    @vehicle = nil
  end

  def is_occupied?
    vehicle.nil?
  end

end
