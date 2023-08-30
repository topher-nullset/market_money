require 'rails_helper'

RSpec.describe "Api::V0::MarketVendors", type: :request do
  describe 'GET /api/v0/markets/:market_id/vendors' do
    it 'returns a JSON response with all vendors of that market' do
      market = create(:market, :with_vendor)

      get "/api/v0/markets/#{market.id}/vendors"
      expect(response).to have_http_status(:success)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('data')

      data = parsed['data']
      expect(data).to be_an(Array)
      expect(data.length).to eq(3)
      
      data.each do |vendor|
        market_id = vendor.dig('relationships', 'markets', 'data', 0, 'id')
        expect(market_id).to eq(market.id.to_s)
      end
    end

    it 'returns a 404 error if the market does not exist' do
      get "/api/v0/markets/1/vendors"

      expect(response).to have_http_status(:not_found)
      
      parsed = JSON.parse(response.body)
      expect(parsed).to include('errors')
      expect(parsed['errors'].first).to include('detail')
      expect(parsed['errors'].first['detail']).to eq("Couldn't find Market with 'id'=1")
    end
  end
end