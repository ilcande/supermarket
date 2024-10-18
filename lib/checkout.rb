# frozen_string_literal: true

require_relative './discount_strategies/discount_factory'

# This class is responsible for scanning items and calculating the total price
class Checkout
  def initialize(pricing_rules)
    @cart = []
    @pricing_rules = pricing_rules
  end

  def scan(item)
    @cart << item
  end

  def total
    total_price = 0
    grouped_items = @cart.group_by(&:code)

    grouped_items.each do |code, items|
      total_price += price_for_items(code, items)
    end

    # Applying 10% discount if total is over £200
    apply_basket_discount(total_price).round(2)
  end

  private

  def price_for_items(code, items)
    pricing_rule = @pricing_rules[code]
    items.first.price * items.size unless pricing_rule

    # Using Factory pattern to get the correct discount strategy based on the pricing rule
    # TODO: Implement the DiscountFactory class
  end

  def apply_basket_discount(total)
    # 10% off for baskets worth over £200
    total > 200 ? total * 0.9 : total
  end
end
