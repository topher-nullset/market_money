module Api
  module V0
    class VendorsController < ApplicationController
      def index
        market = Market.find_by(id: params[:market_id])
        if market
          render json: VendorSerializer.new(market.vendors)
        else
          error_message = "Couldn't find Market with 'id'=#{params[:market_id]}"
          render json: ErrorSerializer.serialize(error_message), status: :not_found
        end
      end

      def show
        vendor = Vendor.find_by(id: params[:id])
        if vendor
          render json: VendorSerializer.new(vendor)
        else
          error_message = "Couldn't find Vendor with 'id'=#{params[:id]}"
          render json: ErrorSerializer.serialize(error_message), status: :not_found
        end
      end

      def create
        vendor = Vendor.new(vendor_params)
        if vendor.save
          render json: VendorSerializer.new(vendor), status: :created
        else
          render json: ErrorSerializer.serialize(vendor.errors), status: :bad_request
        end
      end

      private

      def vendor_params
        params.require(:vendor).permit(:name, :description, :contact_name, :contact_phone, :credit_accepted)
      end
    end
  end
end