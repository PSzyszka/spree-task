FactoryBot.define do
  factory :option_value, class: Spree::OptionValue do
    name { 'Small' }
    presentation    { 'S' }
    option_type
  end

  factory :option_type, class: Spree::OptionType do
    name { 'shirt' }
    presentation    { 'Size' }
  end
end
