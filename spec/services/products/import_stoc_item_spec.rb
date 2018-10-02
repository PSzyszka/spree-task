require 'rails_helper'

RSpec.describe Products::ImportStockItem do
  before { Timecop.freeze(Time.local(2018, 10, 1, 16, 55, 19)) }
  after { Timecop.return }

  describe '.find_or_create_stock_item' do
    let!(:variant) { create(:variant) }

    context 'with valid attributes' do
      let(:row) { { 'stock_total' => '10' } }
      subject { described_class.find_or_create_stock_item(variant, row['stock_total']) }

      context 'when stock_item exist' do
        let!(:stock_item) { create(:stock_item, variant: variant, count_on_hand: row['stock_total']) }
        # TODO: This test doesn't pass, becouse of the line above when creating variant with factory

        it 'does not create new product and returns the previous product' do
          expect { subject }.to change { Spree::StockItem.count }.by(0)
          expect(subject).to eq(stock_item)
        end
      end

      context 'when product whit this attributes do not exist' do
        let!(:stock_item) { create(:stock_item, variant: variant, count_on_hand: 50) }
        # TODO: This test doesn't pass, becouse of the line above when creating variant with factory

        it 'creates new product and returns product' do
          expect { subject }.to change { Spree::StockItem.count }.by(1)
          expect(subject).to be_a(Spree::StockItem)
        end
      end
    end


    context 'with invalid attributes' do
      subject { described_class.find_or_create_stock_item(variant, nil) }

      it 'returns RecordInvalid error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
