# frozen_string_literal: true

# This class is responsible for storing the item code and price
class Item
  attr_reader :code, :price

  def initialize(code, price)
    @code = code
    @price = price
  end
end
