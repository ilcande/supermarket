# frozen_string_literal: true

require_relative '../lib/discount_strategies/discount_factory'
require_relative '../lib/discount_strategies/bulk_purchase_discount'

RSpec.describe DiscountFactory do
  let(:bulk_purchase_rule) { { 'BulkPurchase' => { 'min_items_per_promo' => 2, 'value' => 90 } } }

  it 'creates a BulkPurchaseDiscount when the pricing rule contains BulkPurchase' do
    discount = DiscountFactory.create_discount(bulk_purchase_rule)

    expect(discount).to be_a(BulkPurchaseDiscount)
    expect(discount.instance_variable_get(:@min_items)).to eq(2)
    expect(discount.instance_variable_get(:@discounted_price)).to eq(90)
  end

  it 'raises an error for unsupported discount types' do
    unsupported_rule = { 'SomeOtherDiscount' => { 'value' => 100 } }

    expect { DiscountFactory.create_discount(unsupported_rule) }.to raise_error('Unsupported discount type')
  end
end
