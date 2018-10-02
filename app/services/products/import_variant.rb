module Products
  class ImportVariant
    class << self
      def find_or_create_variant(product, cost_price, category)
        variant = ::Spree::Variant.find_or_initialize_by(
          product: product,
          cost_price: cost_price,
          tax_category: find_or_create_tax_category(category)
        )
        variant.option_values = [find_or_create_option_value(category)]
        variant.save!
        variant
      end

      private

      def find_or_create_tax_category(category)
        ::Spree::TaxCategory.find_or_create_by!(name: category)
      end

      def find_or_create_option_value(category)
        Spree::OptionValue.find_or_create_by!(
          name: 'Small',
          option_type: find_or_create_option_type(category),
          presentation: 'S',
          position: 1
        )
      end

      def find_or_create_option_type(category)
        Spree::OptionType.find_or_create_by!(
          name: define_category_name(category),
          presentation: 'Size'
        )
      end

      def define_category_name(category)
        if category.nil?
          'bag-size'
        else
          word_length = category.size - 2
          "#{(category.slice(0..word_length)).downcase}-size"
        end
      end
    end
  end
end
