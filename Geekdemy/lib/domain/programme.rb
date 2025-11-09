class Programme

  attr_accessor :category_name, :price
  def initialize(programme_category)
    @category_name = programme_category
    @price = self.class.programme_prices[programme_category.to_sym]
  end


  def self.allowed_categories
    ["CERTIFICATION", "DIPLOMA", "DEGREE"]
  end

  def self.programme_prices
    {
      "CERTIFICATION": 3000,
      "DEGREE": 5000,
      "DIPLOMA": 2500
    }
  end
end
