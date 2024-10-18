# frozen_string_literal: true

require_relative '../lib/checkout'
require_relative '../lib/item'

RSpec.describe Checkout do # rubocop:disable Metrics/BlockLength
  let(:pricing_rules) do
    {
      'A' => { 'BulkPurchase' => { 'min_items_per_promo' => 2, 'value' => 90 } },
      'B' => { 'BulkPurchase' => { 'min_items_per_promo' => 3, 'value' => 75 } }
    }
  end

  let(:checkout) { Checkout.new(pricing_rules) }

  it 'calculates the total for a basket without discounts' do
    checkout.scan(Item.new('A', 50))
    checkout.scan(Item.new('B', 30))
    checkout.scan(Item.new('C', 20))

    expect(checkout.total).to eq(100)
  end

  it 'applies bulk purchase discount for A' do
    checkout.scan(Item.new('A', 50))
    checkout.scan(Item.new('A', 50))

    expect(checkout.total).to eq(90)
  end

  it 'applies bulk purchase discount for B' do
    checkout.scan(Item.new('B', 30))
    checkout.scan(Item.new('B', 30))
    checkout.scan(Item.new('B', 30))

    expect(checkout.total).to eq(75)
  end

  it 'applies bulk purchase discount for B and A' do
    checkout.scan(Item.new('A', 50))
    checkout.scan(Item.new('A', 50))
    checkout.scan(Item.new('B', 30))
    checkout.scan(Item.new('B', 30))
    checkout.scan(Item.new('B', 30))

    expect(checkout.total).to eq(165) # 165 total, 2As for 90 and 3Bs for 75
  end

  it 'applies 10% basket discount for baskets over £200, after considering bulk purchase discounts' do
    checkout.scan(Item.new('C', 20))
    checkout.scan(Item.new('B', 30))
    checkout.scan(Item.new('A', 50))
    checkout.scan(Item.new('A', 50))
    checkout.scan(Item.new('C', 20))
    checkout.scan(Item.new('B', 30))
    checkout.scan(Item.new('C', 20))

    expect(checkout.total).to eq(189) # 189 total, 2As for 90, plus 10% discount
  end
end
