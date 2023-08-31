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

      def search
        if invalid_combination_of_parameters?
          error_message = 'Invalid combination of parameters'
          render json: ErrorSerializer.serialize(error_message), status: :unprocessable_entity
        else
          markets = search_markets(params)
          render json: MarketSerializer.new(markets)
        end
      end

      private

      def invalid_combination_of_parameters?
        invalid_combinations = [
          [:city],
          [:city, :name]
        ]
      
        combo = params.keys.map(&:to_sym)

        combo.pop
        combo.pop

        combo.in? invalid_combinations
      end

      def search_markets(params)
        Market.where("name ILIKE ? AND city ILIKE ? AND state ILIKE ?", "%#{params[:name]}%", "%#{params[:city]}%", "%#{params[:state]}%")   
      end
    end
  end
end