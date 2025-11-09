class Cart

  PRO_MEMBERSHIP_FEE = 200
  ENROLLMENT_FEE = 500


  attr_accessor :programmes, :coupon, :pro_membership, :subtotal, :coupon_discount, :pro_membership_fee, \
                :enrollment_fee, :pro_membership_discount, :total
  def initialize
    @programmes = []
    @coupon = nil
    @pro_membership = false
    @subtotal = 0
    @coupon_discount= 0
    @pro_membership_fee = 0
    @enrollment_fee = 0
    @pro_membership_discount = 0
    @total = 0
  end

  def add_programme(programme)
    @programmes.append(programme)
    @subtotal += programme.price
  end

  def add_coupon(coupon)
    @coupon = coupon
    @coupon_discount = coupon.discount_amount
  end

  def add_pro_membership
    @pro_membership = true
    @pro_membership_fee = PRO_MEMBERSHIP_FEE
    @pro_membership_discount = calculate_pro_membership_discount
  end

  def set_enrollment_fee
    @enrollment_fee = ENROLLMENT_FEE
  end

  def set_total
    @total = @subtotal + @pro_membership_fee - @pro_membership_discount  -@coupon_discount + @enrollment_fee
  end

  def min_programme_by_price
    @programmes.min_by{|x| x.price}
  end

  def calculate_pro_membership_discount
    discount = 0
    @programmes.each do |programme|
      if programme.category_name == "CERTIFICATION"
        discount += programme.price * 0.02
      elsif programme.category_name == "DEGREE"
        discount += programme.price * 0.03
      elsif programme.category_name == "DIPLOMA"
        discount += programme.price * 0.01
      else
        next
      end
    end
    discount
  end
end
