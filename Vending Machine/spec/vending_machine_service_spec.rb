
require 'spec_helper'
require 'lib/domain/product'
require 'lib/domain/slot'
require 'lib/domain/vending_machine'

RSpec.describe "VendingMachineServiceSpec" do


  describe "dispense" do

    before(:each) do
      @vending_machine = VendingMachine.new(10, 100)
      @vending_machine_service = VendingMachineService.new(@vending_machine)
      @product = Product.new("Coca-cola", 10)
      5.times do |i|
        slot = @vending_machine.slots.select{|x| x.id == "slot#{i}"}.first
        slot.product = @product
        slot.quantity = 5
      end
    end

    it 'should dispense the product if the product is in stock and current balance is sufficient' do
      expect(@vending_machine_service.dispense("slot1")).to eq({"message": "success", "change": 90})
      expect(@vending_machine.slots.select{|x| x.id == "slot1"}.first.quantity).to eq(4)

    end

    it 'should dispense not dispense the product if the slot does not have the product' do
      expect(@vending_machine_service.dispense("slot8")).to eq({"message": "Failed. Slot is empty"})
    end

    it 'should not dispense if invalid slot number is passed' do
      expect(@vending_machine_service.dispense("slot88")).to eq({"message": "Failed. Invalid Slot"})
    end

    it 'should not dispense the product if the current balance is less than required' do
      @vending_machine = VendingMachine.new(10, 0)
      expect(@vending_machine_service.dispense("slot1")).to eq({"message": "Failed. Not enough balance"})
    end
  end

  describe "insert_money" do

    before(:each) do
      @vending_machine = VendingMachine.new(10, 0)
      @vending_machine_service = VendingMachineService.new(@vending_machine)
    end

    it 'should increase the balance correctly' do
      @vending_machine_service.insert_money(100)
      expect(@vending_machine.current_balance).to eq(100)
    end
  end
end
