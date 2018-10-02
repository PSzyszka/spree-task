FactoryBot.define do
  factory :stock_item, class: Spree::StockItem do
    count_on_hand { 20 }
    stock_location
    variant

    after(:create) { |object| object.adjust_count_on_hand(10) }
  end
end
