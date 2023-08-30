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
end