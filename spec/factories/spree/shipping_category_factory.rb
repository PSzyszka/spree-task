FactoryBot.define do
  factory :shipping_category, class: Spree::ShippingCategory do
    sequence(:name) { 'Name' }
  end
end
