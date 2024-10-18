# frozen_string_literal: true

require_relative '../lib/discount_strategies/bulk_purchase_discount'
require_relative '../lib/item'

RSpec.describe BulkPurchaseDiscount do
  let(:items) { [Item.new('A', 50), Item.new('A', 50)] }
  let(:bulk_discount) { BulkPurchaseDiscount.new(2, 90) } # 2 items for 90

  it 'applies the bulk purchase discount when the number of items meets the threshold' do
    total_price = bulk_discount.apply(items)
    expect(total_price).to eq(90)
  end

  it 'applies the full price for remaining items if the total is not divisible by the minimum' do
    items << Item.new('A', 50) # Added 1 more item (3 A items total)
    total_price = bulk_discount.apply(items)

    expect(total_price).to eq(140) # 2 items for 90 + 1 item for 50
  end

  it 'returns full price when the number of items is below the discount threshold' do
    items = [Item.new('A', 50)] # Only 1 item
    total_price = bulk_discount.apply(items)

    expect(total_price).to eq(50) # No discount applied
  end

  it 'applies the bulk purchase discount when the number of items doubles the threshold' do
    items << Item.new('A', 50) # Added 1 more item (3 A items total)
    items << Item.new('A', 50) # Added 1 more item (4 A items total)
    total_price = bulk_discount.apply(items)

    expect(total_price).to eq(180) # 4 items for 180
  end
end
