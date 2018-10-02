require 'rails_helper'

RSpec.describe Products::Import do
  describe '#call' do
    context 'when there is no file attached' do
      it 'raises MissingFileError' do
        file = nil
        col_sep = ','

        expect { described_class.new.call(file, col_sep) }
          .to raise_error(Products::Import::MissingFileError)
      end
    end

    context 'when there is a file attached' do
      context 'and it has valid data' do
        it 'changes the count of product, variant and stock_item' do
          file = instance_double(File)
          col_sep = ','
          csv_file = build_csv(2)
          allow(file).to receive(:path)
          allow(File).to receive(:open).and_return(csv_file)

          expect { described_class.new.call(file, col_sep) }
            .to change { Spree::Product.count }.by(1)
            .and change { Spree::Variant.count }.by(1)
            .and change { Spree::StockItem.count }.by(1)
        end
      end

      context 'and it has invalid data' do
        it 'raises Products Import Error' do
          file = instance_double(File)
          col_sep = ','
          csv_file = build_csv(2, :invalid)
          allow(file).to receive(:path)
          allow(File).to receive(:open).and_return(csv_file)

          expect { described_class.new.call(file, col_sep) }.to raise_error(Products::Import::Error)
        end
      end
    end
  end

  def valid_row_data
    {
      'name' => 'Bag',
      'description' => 'Some awesome bag',
      'price' => '13.99',
      'availability_date' => '2017-12-04T14:55:22',
      'slug' => 'ruby-on-rails-bag',
      'stock_total' => '15',
      'category' => 'Bags'
    }
  end

  def invalid_row_data
    {
      'name' => '',
      'description' => 'Some awesome bag',
      'price' => '13.99',
      'availability_date' => '2017-12-04T14:55:22',
      'slug' => 'ruby-on-rails-bag',
      'stock_total' => '15',
      'category' => 'Bags'
    }
  end

  def build_csv(row_amount = 3, data_type = :valid)
    column_names = [
      'name', 'description', 'price', 'availability_date', 'slug', 'stock_total', 'category'
    ]

    CSV.generate do |csv|
      csv << column_names
      (1..row_amount).each do
        csv << generate_row(column_names, data_type)
      end
    end
  end

  def generate_row(column_names, data_type)
    values =
      if data_type == :valid
        column_names.map { |column_name| valid_row_data[column_name] }
      else
        column_names.map { |column_name| invalid_row_data[column_name] }
      end

    CSV::Row.new(column_names, values)
  end
end
