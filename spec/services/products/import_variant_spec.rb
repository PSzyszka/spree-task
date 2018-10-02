require 'rails_helper'

RSpec.describe Products::ImportVariant do
  before { Timecop.freeze(Time.local(2018, 10, 1, 16, 55, 19)) }
  after { Timecop.return }

  describe '.find_or_create_variant' do
    let!(:product) { create(:product, slug: 'new-black-big-shirt') }

    context 'with valid attributes' do
      let(:row) { { 'price' => '20.19', 'category' => 'shirt' } }
      subject do
        described_class.find_or_create_variant(product, row['price'].to_f, row['category'])
      end

      context 'when variant exist' do
        let!(:tax_category) { create(:tax_category) }
        let!(:variant) { create(:variant, product: product, tax_category: tax_category) }
        # TODO: This test doesn't pass, becouse of the line above when creating variant with factory

        it 'does not create new variant and returns the previous variant' do
          expect { subject }.to change { Spree::Variant.count }.by(0)
          expect(subject).to eq(variant)
        end
      end

      context 'when variant whit this attributes do not exist' do
        let!(:variant) { create(:variant, price: 298.00, cost_price: 298.00, product: product) }

        it 'creates new variant and returns variant' do
          expect { subject }.to change { Spree::Variant.count }.by(1)
          expect(subject).to be_a(Spree::Variant)
        end
      end
    end


    context 'with invalid attributes' do
      let(:row) { { 'price' => '20.19', 'category' => 'shirt' } }

      subject do
        described_class.find_or_create_variant(product, row['price'].to_f, row['category'])
      end

      it 'returns RecordInvalid error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
