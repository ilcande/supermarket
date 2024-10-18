# frozen_string_literal: true

require_relative './checkout'
require_relative './item'

# Load the pricing rules
pricing_rules = {
  'A' => { 'BulkPurchase' => { 'min_items_per_promo' => 2, 'value' => 90 } },
  'B' => { 'BulkPurchase' => { 'min_items_per_promo' => 3, 'value' => 75 } }
}

# A, B, C ->	£100
checkout = Checkout.new(pricing_rules)
checkout.scan(Item.new('A', 50))
checkout.scan(Item.new('B', 30))
checkout.scan(Item.new('C', 20))
price = checkout.total
puts "A, B, C -> £#{price}"

# A, A -> £90
checkout_two = Checkout.new(pricing_rules)
checkout_two.scan(Item.new('A', 50))
checkout_two.scan(Item.new('A', 50))
price_two = checkout_two.total
puts "A, A -> £#{price_two}"

# B, B, B -> £75
checkout_three = Checkout.new(pricing_rules)
checkout_three.scan(Item.new('B', 30))
checkout_three.scan(Item.new('B', 30))
checkout_three.scan(Item.new('B', 30))
price_three = checkout_three.total
puts "B, B, B -> £#{price_three}"

# A, A, B, B, B -> £165
checkout_four = Checkout.new(pricing_rules)
checkout_four.scan(Item.new('A', 50))
checkout_four.scan(Item.new('A', 50))
checkout_four.scan(Item.new('B', 30))
checkout_four.scan(Item.new('B', 30))
checkout_four.scan(Item.new('B', 30))
price_four = checkout_four.total
puts "A, A, B, B, B -> £#{price_four}"

# C, B, A, A, C, B, C -> £189
# 2As for 90, plus 10% discount
checkout_five = Checkout.new(pricing_rules)
checkout_five.scan(Item.new('C', 20))
checkout_five.scan(Item.new('B', 30))
checkout_five.scan(Item.new('A', 50))
checkout_five.scan(Item.new('A', 50))
checkout_five.scan(Item.new('C', 20))
checkout_five.scan(Item.new('B', 30))
checkout_five.scan(Item.new('C', 20))
price_five = checkout_five.total
puts "C, B, A, A, C, B, C -> £#{price_five}"
