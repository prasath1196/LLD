class Vehicle

  MOTORCYCLE='motorcycle'
  CAR='car'
  VAN='van'

  attr_accessor :type
  def initialize(type)
    @type = type
  end

  class << self
    def allowed_types
      [CAR, MOTORCYCLE, VAN]
    end
  end

end
