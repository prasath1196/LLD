class CartService

    def initialize(cart)
      @cart = cart
    end

    def add_programme(category_name, quantity)
      quantity.times do
        @cart.add_programme(Programme.new(category_name))
      end
      apply_automatic_discount
    end

    def apply_coupon(coupon)
      return unless @cart.coupon.nil?

      if coupon.coupon_name == "DEAL_G20" and @cart.subtotal >= 10000
        coupon.discount_amount = 0.20 * @cart.subtotal
      elsif coupon.coupon_name == "DEAL_G5" and @cart.programmes.size >= 2
        coupon.discount_amount =  0.05 * @cart.subtotal
      else
        return
      end
      @cart.add_coupon(coupon) if @cart.coupon.nil? or @cart.coupon.discount_amount < coupon.discount_amount
    end

    def add_pro_membership
      return if @cart.pro_membership
      @cart.add_pro_membership
    end

    def apply_automatic_discount
      if @cart.programmes.size >= 4
        min_program_price = @cart.min_programme_by_price&.price
        @cart.add_coupon(Coupon.new("B4G1", min_program_price))
      end
    end

    def print_bill
      @cart.set_total
      if @cart.total < 6666
        @cart.set_enrollment_fee
      end
      @cart.set_total
      coupon_discount = 0
      coupon_discount = @cart.coupon.discount_amount if @cart.coupon
      ["SUB_TOTAL  %.2f" % @cart.subtotal,
              "COUPON_DISCOUNT  #{@cart.coupon&.coupon_name}  %.2f" % coupon_discount,
              "TOTAL_PRO_DISCOUNT  %.2f" % @cart.pro_membership_discount,
              "PRO_MEMBERSHIP_FEE  %.2f" % @cart.pro_membership_fee,
              "ENROLLMENT_FEE  %.2f" % @cart.enrollment_fee,
              "TOTAL %.2f" % @cart.total]
    end
end
