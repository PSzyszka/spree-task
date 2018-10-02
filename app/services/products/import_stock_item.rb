module Products
  class ImportStockItem
    class << self
      def find_or_create_stock_item(variant, stock_total)
        stock_location = find_or_create_location

        stock_item = ::Spree::StockItem.find_or_initialize_by(
          variant: variant,
          count_on_hand: stock_total,
          stock_location: stock_location
        )
        stock_item.save!
      end

      private

      def find_or_create_location
        Spree::StockLocation.find_or_create_by(name: 'default', propagate_all_variants: false)
      end
    end
  end
end
