# frozen_string_literal: true

# This class is responsible for applying a bulk purchase discount to a list of items
class BulkPurchaseDiscount
  def initialize(min_items, discounted_price)
    @min_items = min_items
    @discounted_price = discounted_price
  end

  def apply(items)
    full_price = items.first.price
    total_price = 0
    groups_of_discount = items.length / @min_items
    remaining_items = items.length % @min_items

    total_price += groups_of_discount * @discounted_price
    total_price += remaining_items * full_price
    total_price
  end
end
