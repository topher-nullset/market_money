module Api
  module V0
    class MarketVendorsController < ApplicationController
      def create
        market = Market.find_by(id: params[:market_id])
        if market
          vendor = Vendor.find_by(id: params[:vendor_id])
          if vendor
            market_vendor = MarketVendor.new(market: market, vendor: vendor)
            if market_vendor.save
              render json: MarketVendorSerializer.new(market_vendor), status: :created
            else
              render json: ErrorSerializer.serialize(market_vendor.errors), status: :bad_request
            end
          else
            error_message = "Couldn't find Vendor with 'id'=#{params[:vendor_id]}"
            render json: ErrorSerializer.serialize(error_message), status: :not_found
          end
        else
          error_message = "Couldn't find Market with 'id'=#{params[:market_id]}"
          render json: ErrorSerializer.serialize(error_message), status: :not_found
        end
      end

      def destroy
        market_vendor = MarketVendor.find_by(market_id: params[:market_id], vendor_id: params[:vendor_id])
        if market_vendor
          market_vendor.destroy
        else
          error_message = "Couldn't find MarketVendor with market_id=#{params[:market_id]} and vendor_id=#{params[:vendor_id]}"
          render json: ErrorSerializer.serialize(error_message), status: :not_found
        end
      end
    end
  end
end

