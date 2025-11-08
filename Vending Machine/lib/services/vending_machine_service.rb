class VendingMachineService

  attr_accessor :vending_machine

  def initialize(vending_machine)
    @vending_machine = vending_machine
  end

  def display_items
    slots = @vending_machine.slots
    inventory = []
    slots.each do |slot|
      product = slot.product
      if product
        inventory << {slot_id: slot.id, product_name: product.name, price: product.price, stock: slot.quantity}
      end
    end
    return inventory
  end

  def dispense(slot_id)
    slot = @vending_machine.slots.select{|x| x.id == slot_id}&.first
    current_balance = @vending_machine.current_balance
    return {"message": "Failed. Invalid Slot"} if slot.nil? or slot.product.nil?

    return {"message": "Failed. Slot is empty"} if slot.quantity.zero?

    product = slot.product
    return {"message": "Failed. Insufficient Balance"} if product.price > current_balance

    change = @vending_machine.dispense_product(slot_id)
    @vending_machine.rest_balance
    return {"message": "Success", "change": change}
  end

  def load(product, quantity)
    return {"message": "Failed. Quantity is greater than slot size"} if quantity > @vending_machine.slot_size

    return {"message": "Invalid Product"} if product.nil? or product.price.nil? or product.name.nil?

    @vending_machine.load_product(product, quantity)
  end

  def insert_money(amount)
    @vending_machine.add_balance(amount)
  end

  def cancel_request
    balance = @vending_machine.current_balance
    @vending_machine.rest_balance
    return {"message": "Success", "change": balance}
  end

end
