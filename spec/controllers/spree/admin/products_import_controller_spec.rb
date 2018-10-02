require 'rails_helper'
# require 'spree/testing_support/factories'

RSpec.describe Spree::Admin::ProductsImportController, type: :controller do
  let(:admin_user) { FactoryBot.create(:admin_user) }
  before { login_as(admin_user, scope: :spree_user) }

  describe 'GET new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'POST import' do
    context 'with valid csv file' do
      context 'with defined valid sepator' do
        it 'redirects to root_url and renders flash notice' do
          products_import = double(:products_import, call: nil)
          allow(Products::Import).to receive(:new).and_return(products_import)

          params = { file: 'path_to/file.csv', col_separator: ';' }
          post :import

          expect(response).to redirect_to(root_url)
          expect(flash[:notice]).to eq('Products imported.')
        end
      end

      context 'with default valid sepator' do
        it 'redirects to root_url and renders flash notice' do
          products_import = double(:products_import, call: nil)
          allow(Products::Import).to receive(:new).and_return(products_import)

          params = { file: 'path_to/file.csv' }
          post :import

          expect(response).to redirect_to(root_url)
          expect(flash[:notice]).to eq('Products imported.')
        end
      end
    end

    context 'with invalid csv file' do
      it 'renders new template with flash error' do
        products_import = double(:products_import, call: nil)
        error = 'Invalid file'
        allow(Products::Import).to receive(:new).and_return(error)

        expect(response).to render_template('new')
        expect(flash[:error]).to eq('Invalid file')
      end
    end
  end
end
