module Api
  module V0
    class MarketsController < ApplicationController
      def index
        render json: MarketSerializer.new(Market.all)
      end

      def show
        market = Market.find_by(id: params[:id])
        if market
          render json: MarketSerializer.new(market)
        else
          error_message = "Couldn't find Market with 'id'=#{params[:id]}"
          render json: ErrorSerializer.serialize(error_message), status: :not_found
        end
      end
    end
  end
end