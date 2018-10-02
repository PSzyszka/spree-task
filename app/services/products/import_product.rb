module Products
  class ImportProduct
    class << self
      def find_or_create_product(row)
        product = ::Spree::Product.find_or_initialize_by(
          name: row['name'],
          description: row['description'],
          available_on: row['availability_date'],
          slug: row['slug'],
          shipping_category: find_or_create_shipping_category
        )
        product.price = row['price']&.to_f
        product.save!
        product
      end

      private

      def find_or_create_shipping_category
        ::Spree::ShippingCategory.find_or_create_by!(name: 'Default')
      end
    end
  end
end
