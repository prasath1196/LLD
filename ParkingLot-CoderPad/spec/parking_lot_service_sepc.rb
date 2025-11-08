require 'spec_helper'
require "domain/parking_lot"
require "domain/parking_slot"
require "domain/vehicle"
require "services/parking_lot_service"
RSpec.describe 'ParkingLotServiceSpec'  do


   describe 'When testing is_empty?' do
    it 'should return true if the parking slot is empty' do
      @parking_lot = ParkingLot.new(20, 10, 10, ParkingSlot)
      @parking_lot_service = ParkingLotService.new(@parking_lot)
      expect(@parking_lot_service.is_empty()).to eq(true)
    end

    it 'should return the false if the parking slot is full' do
      @parking_lot = ParkingLot.new(20, 10, 10, ParkingSlot)
      @parking_lot_service = ParkingLotService.new(@parking_lot)
      20.times do |i|
        slot = @parking_lot.slots[i]
        if slot.type == "motorcycle"
             slot.vehicle = Vehicle.new("motorcycle")
        else
             slot.vehicle = Vehicle.new("car")
        end
      end
      expect(@parking_lot_service.is_empty()).to eq(false)
    end
  end

  describe 'When testing remaining spots' do
    before(:each) do
      @parking_lot = ParkingLot.new(20, 10, 10, ParkingSlot)
      @parking_lot_service = ParkingLotService.new(@parking_lot, Vehicle)
      mc_slots = @parking_lot.slots.select{|x| x  if x.type == "motorcycle"}
      mc_slots.each do |slot|
        slot.vehicle = Vehicle.new("motorcycle")
      end
    end
    it 'should return the count correctly for remaining spots' do
      expect(@parking_lot_service.remaining_spots()).to eq(10)
    end

    it 'should return remainign motorcycle spots when params is motorcycle' do
      expect(@parking_lot_service.remaining_spots("motorcycle")).to eq(10)
    end

    it 'should return remainign motorcycle spots when params is cars' do
      expect(@parking_lot_service.remaining_spots("car")).to eq(10)

    end

    it 'should return remainign motorcycle spots when params is vans' do
      expect(@parking_lot_service.remaining_spots("van")).to eq(3)

    end

    it 'return invalid vehicle for invalid vehicle types' do
      expect(@parking_lot_service.remaining_spots("sedan")).to eq("Invalid Vehicle Type")
    end
  end

  describe 'When testing toal spots' do
    before(:each) do
      @parking_lot = ParkingLot.new(20, 10, 10, ParkingSlot)
      @parking_lot_service = ParkingLotService.new(@parking_lot, Vehicle)
      mc_slots = @parking_lot.slots.select{|x| x  if x.type == "motorcycle"}
      mc_slots.each do |slot|
        slot.vehicle = Vehicle.new("motorcycle")
      end
    end
    it 'should return the count correctly for total spots' do
      expect(@parking_lot_service.total_spots()).to eq(@parking_lot.capacity)
    end

    it 'should return remainign motorcycle spots when params is motorcycle' do
      expect(@parking_lot_service.total_spots("motorcycle")).to eq(20)
    end

    it 'should return remainign motorcycle spots when params is cars' do
      expect(@parking_lot_service.total_spots("car")).to eq(10)
    end

    it 'should return remainign motorcycle spots when params is vans' do
      expect(@parking_lot_service.total_spots("van")).to eq(3)
    end

    it 'return invalid vehicle for invalid vehicle types' do
      expect(@parking_lot_service.total_spots("sedan")).to eq("Invalid Vehicle Type")
    end
  end

  describe 'When testing park' do
    before(:each) do
      @parking_lot = ParkingLot.new(20, 10, 10, ParkingSlot)
      @parking_lot_service = ParkingLotService.new(@parking_lot, Vehicle)
    end

    it 'should return "No Slots" when there are no slots' do

    end

    it 'should return "Invalid Vehicle" when the vehicle type is invalid' do
      expect(@parking_lot_service.park(Vehicle.new('sedan'))).to eq("Invalid Vehicle Type")
    end

    it 'should return "No Slots for this vehicle" when particular vechicle slot is not available' do
      10.times do
        @parking_lot_service.park(Vehicle.new('car'))
      end
      expect(@parking_lot_service.park(Vehicle.new("van"))).to eq("No Slots for this vehicle")
    end

    it 'should return number of remaining slot for that vehicle when slot is available' do
      expect(@parking_lot_service.park(Vehicle.new("motorcycle"))).to eq(true)
      expect(@parking_lot_service.remaining_spots('motorcycle')).to eq(19)
    end

    it 'should reduce available slot correctly for car' do
      expect(@parking_lot_service.park(Vehicle.new("car"))).to eq(true)
      expect(@parking_lot_service.remaining_spots('car')).to eq(9)
    end

    it 'should reduce available slot correctly for vans' do
      expect(@parking_lot_service.park(Vehicle.new("van"))).to eq(true)
      expect(@parking_lot_service.remaining_spots('van')).to eq(2)

    end
  end

end
