FactoryBot.define do
  factory :base_product, class: Spree::Product do
    sequence(:name)   { 'New Black Big Shirt' }
    description       { 'Black' }
    price             { 20.19 }
    cost_price        { 20.19 }
    available_on      { Date.new(2018, 10, 2) }
    deleted_at        { nil }
    shipping_category

    # ensure stock item will be created for this products master
    before(:create) { create(:stock_location) if Spree::StockLocation.count == 0 }

    factory :custom_product do
      name  { 'Custom Product' }
      price { 17.99 }

      tax_category { |r| Spree::TaxCategory.first || r.association(:tax_category) }
    end

    factory :product do
      tax_category { |r| Spree::TaxCategory.first || r.association(:tax_category) }

      factory :product_in_stock do
        after :create do |product|
          product.master.stock_items.first.adjust_count_on_hand(10)
        end
      end

      factory :product_with_option_types do
        after(:create) { |product| create(:product_option_type, product: product) }
      end
    end
  end
end
