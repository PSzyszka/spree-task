require 'csv'

module Products
  class Import
    Error = Class.new(StandardError)
    MissingFileError = Class.new(Error)
    InvalidRowError = Class.new(Error)

    def call(file, col_sep)
      raise MissingFileError, 'No file was attached.' if file.blank?
      row_number = 2
      errors = []

      CSV.foreach(file.path, headers: true, col_sep: col_sep) do |row|
        ActiveRecord::Base.transaction do
          product = ::Products::ImportProduct.find_or_create_product(row)
          variant = ImportVariant.find_or_create_variant(product, row['price']&.to_f, row['category'])
          ImportStockItem.find_or_create_stock_item(variant, row['stock_total']&.to_i)
        end
      rescue ActiveRecord::RecordInvalid => e
        errors << "Row #{row_number}: #{e.message}"
      rescue StandardError => e
        errors << "Row #{row_number}: #{e.message}"
      ensure
        row_number += 1
      end

      unless errors.empty?
        raise Error, errors.join('<br/>').html_safe
      end
    end
  end
end
