module Api
  module V0
    class MarketsController < ApplicationController
      def index
        @markets = Market.includes(:vendors)
        render json: @markets, methods: :vendor_count
      end

    end
  end
end