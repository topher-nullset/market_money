module Api
  module V0
    class MarketsController < ApplicationController
      def index
        @markets = Market.all
        render json: @markets
      end

    end
  end
end