# frozen_string_literal: true

require_relative '../lib/item'

RSpec.describe Item do
  let(:item) { Item.new('A', 50) }

  it 'initializes with a code and a price' do
    expect(item.code).to eq('A')
    expect(item.price).to eq(50)
  end

  it 'returns the correct code' do
    expect(item.code).to eq('A')
  end

  it 'returns the correct price' do
    expect(item.price).to eq(50)
  end
end
