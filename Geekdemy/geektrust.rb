require_relative 'lib/domain/cart'
require_relative 'lib/domain/programme'
require_relative 'lib/domain/coupon'
require_relative 'lib/services/cart_service'

# Minimal placeholder to avoid NameError if not implemented elsewhere.
class CommandSession; end

def main
  cart = Cart.new
  cart_service = CartService.new(cart)
  bg4 = Coupon.new("BG4")
  deal_g20 = Coupon.new("DEAL_G20")
  deal_g5 = Coupon.new("DEAL_G5")
  fileinput = ARGV[0]
  file = File.open(fileinput)
  session = CommandSession.new
  file.readlines.each do |line|
      inputs = line.split(" ")
      command = inputs[0]

      if command == "ADD_PROGRAMME"
        category = inputs[1]
        quantity = inputs[2]
        cart_service.add_programme(category, quantity.to_i)
      elsif command == "APPLY_COUPON"
        coupon_name = inputs[1]
        if coupon_name == "DEAL_G20"
          cart_service.apply_coupon(deal_g20)
        elsif coupon_name == "DEAL_G5"
          cart_service.apply_coupon(deal_g5)
        end
      elsif command == "ADD_PRO_MEMBERSHIP"
        cart_service.add_pro_membership
      elsif command == "PRINT_BILL"
        print(cart_service.print_bill.join("\n"))
      end
  end
end

main
