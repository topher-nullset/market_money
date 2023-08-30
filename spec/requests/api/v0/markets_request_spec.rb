require 'rails_helper'

RSpec.describe "Api::V0::Markets", type: :request do
  describe 'GET /api/v0/markets' do
    it 'returns a JSON response with all markets and vendor count' do
      markets = create_list(:market, 3, :with_vendor)

      get '/api/v0/markets'
      expect(response).to have_http_status(:success)

      parsed = JSON.parse(response.body)
      expect(parsed.length).to eq(3)

      first = parsed.first
      expect(first).to include('vendor_count')
      expect(first['vendor_count']).to eq(3)
    end
  end

  describe 'GET /api/v0/markets/:id' do
    it 'returns a JSON response with a market and vendor count' do
      market = create(:market, :with_vendor)

      get "/api/v0/markets/#{market.id}"
      expect(response).to have_http_status(:success)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('vendor_count')
      expect(parsed['vendor_count']).to eq(3)
    end

    it 'returns a 404 error if the market does not exist' do
      get "/api/v0/markets/1"
      expect(response).to have_http_status(:not_found)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('errors')
      expect(parsed['errors'].first).to include('detail')
      expect(parsed['errors'].first['detail']).to eq("Couldn't find Market with 'id'=1")
    end
  end
end