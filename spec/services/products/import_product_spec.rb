require 'rails_helper'

RSpec.describe Products::ImportProduct do
  before { Timecop.freeze(Time.local(2018, 10, 1, 16, 55, 19)) }
  after { Timecop.return }

  describe '.find_or_create_product' do
    context 'with valid attributes' do
      let(:row) do
        {
          'name' => 'New Black Big Shirt',
          'description' => 'Black',
          'price' => '20.19',
          'availability_date' => Date.new(2018, 10, 2).to_s,
          'slug' => 'new-black-big-shirt',
          'stock_total' => '10',
          'category' => 'shirt'
        }
      end

      subject { described_class.find_or_create_product(row) }

      context 'when product exist' do
        let!(:product) { create(:product, slug: nil) }
        # TODO: This test doesn't pass, becouse of the line above when creating product with factory

        it 'does not create new product and returns the previous product' do
          expect { subject }.to change { Spree::Product.count }.by(0)
          expect(subject).to eq(product)
        end
      end

      context 'when product whit this attributes do not exist' do
        let!(:product) { create(:product, name: 'Big Shirt') }

        it 'creates new product and returns product' do
          expect { subject }.to change { Spree::Product.count }.by(1)
          expect(subject).to be_a(Spree::Product)
        end
      end
    end


    context 'with invalid attributes' do
      let(:row) do
        {
          'name' => '',
          'description' => 'Black',
          'price' => '20.19',
          'availability_date' => Date.new(2018, 10, 2).to_s,
          'slug' => 'new-black-big-shirt',
          'stock_total' => '10',
          'category' => 'shirt'
        }
      end

      subject { described_class.find_or_create_product(row) }

      it 'returns RecordInvalid error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
