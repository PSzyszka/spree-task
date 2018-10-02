module Spree
  module Admin
    class ProductsImportController < ResourceController
      before_action :load_resource, except: :new

      def new
      end

      def import
        col_separator = params[:column_separtor].presence || ';'

        ::Products::Import.new.call(params[:file], col_separator)
        redirect_to root_url, notice: 'Products imported.'
      rescue Products::Import::Error => e
        flash[:error] = e.message
        render 'new'
      end

      private

      def model_class
      end
    end
  end
end
