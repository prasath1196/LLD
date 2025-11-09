class Coupon

  attr_accessor :coupon_name, :discount_amount
  def initialize(coupon_name, discount_amount=0)
      @coupon_name = coupon_name
      @discount_amount = discount_amount
  end


end
