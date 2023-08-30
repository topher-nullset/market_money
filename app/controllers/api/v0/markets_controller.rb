module Api
  module V0
    class MarketsController < ApplicationController
      def index
        @markets = Market.includes(:vendors)
        render json: @markets, methods: :vendor_count
      end

      def show
        @market = Market.find_by(id: params[:id])
        if @market
          render json: @market, methods: :vendor_count
        else
          render json: { errors: [{ detail: "Couldn't find Market with 'id'=#{params[:id]}" }] }, status: :not_found
        end
      end
    end
  end
end