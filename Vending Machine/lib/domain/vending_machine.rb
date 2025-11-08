

class VendingMachine

  attr_accessor :slots, :current_balance, :slot_size
  def initialize(number_of_slots, slot_size=5)
    @slots = []
    @current_balance = 0
    @slot_size = slot_size
    initialize_slots(number_of_slots)
  end


  def add_balance(amount)
    @current_balance += amount
  end

  def rest_balance
    @current_balance = 0
  end

  def load_product(product, quantity)
    slot = @slots.find{|x| x.product == nil}
    slot.product = product
    slot.quantity = quantity
    slot
  end

  def dispense_product(slot_id, quantity =1)
    slot = @slots.find{|x| x.id == slot_id}
    slot.quantity -= 1
    change = @current_balance - slot.product.price
    change
  end

  private

  def initialize_slots(count)
    count.times do |i|
      @slots << Slot.new("slot#{i}", nil, @slot_size)
    end
  end
end
