
class Slot

  attr_accessor :id, :product, :size, :quantity
  def initialize(id, product=nil, size=5, quantity = 5)
    @id = id
    @product = product
    @size = size
    @quantity = quantity
  end
end
