class ParkingLotService

  attr_accessor :parking_lot, :vehicle_klass
  def initialize(parking_lot, vehicle_klass=Vehicle)
    @parking_lot = parking_lot
    @vehicle_klass = vehicle_klass
  end

  def park(vehicle)
    return "Invalid Vehicle Type" unless is_valid_vehicle_type?(vehicle.type)
    empty_slots = remaining_spots()
    return "No Slots Left" if empty_slots == 0

    vehicle_slots = remaining_spots(vehicle.type)
    return "No Slots for this vehicle" if vehicle_slots == 0

    @parking_lot.add_vehicle_to_slot(vehicle)
  end


  def is_empty()
    @parking_lot.slots.all? { |slot| slot.vehicle.nil? }
  end

  def remaining_spots(type='all')
    if type != "all" && !is_valid_vehicle_type?(type)
      return "Invalid Vehicle Type"
    end
    return @parking_lot.count_empty_slots(type)
  end

  def total_spots(type="all")
    if type != "all" &&  !is_valid_vehicle_type?(type)
      return "Invalid Vehicle Type"
    end

    return @parking_lot.count_total_spots(type)
  end

  private

  def is_valid_vehicle_type?(type)
    @vehicle_klass.allowed_types.include?(type)
  end

end
