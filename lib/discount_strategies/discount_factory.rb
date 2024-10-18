# frozen_string_literal: true

require_relative './bulk_purchase_discount'

# This class is responsible for creating the correct discount object based on the pricing rules
class DiscountFactory
  def self.create_discount(pricing_rule)
    raise 'Unsupported discount type' unless pricing_rule.key?('BulkPurchase')

    BulkPurchaseDiscount.new(pricing_rule['BulkPurchase']['min_items_per_promo'], pricing_rule['BulkPurchase']['value'])
  end
end
