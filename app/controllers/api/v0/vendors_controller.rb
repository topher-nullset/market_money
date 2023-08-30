module Api
  module V0
    class VendorsController < ApplicationController
      def index
        market = Market.find_by(id: params[:market_id])
        if market
          render json: VendorSerializer.new(market.vendors)
        else
          render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:market_id]}" }] }, status: :not_found
        end
      end

      def show
        vendor = Vendor.find_by(id: params[:id])
        if vendor
          render json: VendorSerializer.new(vendor)
        else
          render json: { errors: [{ detail: "Couldn't find Vendor with 'id'=#{params[:id]}" }] }, status: :not_found
        end
      end
    end
  end
end