class ParkingLot

  attr_accessor :capacity, :slots, :motorcycle_spots_size, :regular_spots_size, :parking_slot_klass, :vehicle_klass

  def initialize(capacity=20, motorcycle_spots_size=10, regular_spots_size= 10, parking_slot_klass)
    @capacity = capacity
    @motorcycle_spots_size = motorcycle_spots_size
    @regular_spots_size = regular_spots_size
    @slots = []
    @parking_slot_klass = parking_slot_klass
    @vehicle_klass = Vehicle
    initialize_parking_slots
  end

  def count_empty_slots(type="all")
    empty_slots = @slots.select { |slot| slot.vehicle.nil? }
    return empty_slots.size if type == "all"

    if type == @vehicle_klass::VAN
      return count_non_overlapping_van_slots
    elsif type == @vehicle_klass::MOTORCYCLE
      return empty_slots.count { |s| s.type == @vehicle_klass::MOTORCYCLE || s.type == "regular" }
    elsif type == @vehicle_klass::CAR
      return empty_slots.count { |s| s.type == "regular" }
    else
      return 0
    end
  end

  def count_total_spots(type = "all")
    return @slots.size if type == "all"

    if type == @vehicle_klass::VAN
      return (@slots.count { |slot| slot.type == "regular" } / 3).to_i
    elsif type == @vehicle_klass::MOTORCYCLE
      return @slots.count { |s| s.type == @vehicle_klass::MOTORCYCLE || s.type == "regular" }
    elsif type == @vehicle_klass::CAR
      return @slots.count { |s| s.type == "regular" }
    else
      return 0
    end
  end

  def add_vehicle_to_slot(vehicle)
    slots_to_park = find_slots_for_vehicle(vehicle.type)
    return false if slots_to_park.empty?

    slots_to_park.each do |slot|
      slot.vehicle = vehicle
    end
    return true
  end

  private

  def find_slots_for_vehicle(type)
    if type == @vehicle_klass::VAN
      return find_first_available_van_block || []
    elsif type == @vehicle_klass::MOTORCYCLE
      spot = @slots.find { |s| s.type == @vehicle_klass::MOTORCYCLE && s.vehicle.nil? }
      spot ||= @slots.find { |s| s.type == "regular" && s.vehicle.nil? }
      return spot ? [spot] : []
    elsif type == @vehicle_klass::CAR
      spot = @slots.find { |s| s.type == "regular" && s.vehicle.nil? }
      return spot ? [spot] : []
    else
      return []
    end
  end

  def find_first_available_van_block
    @slots.each_cons(3).find do |slot_block|
      slot_block.all? { |slot| slot.type == "regular" && slot.vehicle.nil? }
    end
  end

  def count_non_overlapping_van_slots
    count = 0
    i = 0
    while i <= @slots.length - 3
      block = @slots[i, 3]
      if block.all? { |s| s.type == "regular" && s.vehicle.nil? }
        count += 1
        i += 3
      else
        i += 1
      end
    end
    return count
  end

  def initialize_parking_slots
    @motorcycle_spots_size.times do |i|
      @slots << @parking_slot_klass.new(@vehicle_klass::MOTORCYCLE, "#PSMOT#{i}")
    end

    @regular_spots_size.times do |i|
      @slots << @parking_slot_klass.new("regular","#PSREG#{i}")
    end
  end

end
