require 'rails_helper'

RSpec.describe "Api::V0::MarketVendors", type: :request do
  describe 'POST /api/v0/market_vendors/' do
    it 'creates a market vendor' do
      market = create(:market)
      vendor = create(:vendor)
      params = {market_id: market.id, vendor_id: vendor.id}

      post "/api/v0/market_vendors/", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:created)
      parsed = JSON.parse(response.body)
      expect(parsed['data']['relationships']['market']['data']['id']).to eq(market.id.to_s)
      expect(parsed['data']['relationships']['vendor']['data']['id']).to eq(vendor.id.to_s)
    end

    it 'returns an error if the market does not exist' do
      vendor = create(:vendor)
      params = {vendor_id: vendor.id, market_id: 999}

      post "/api/v0/market_vendors/", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:not_found)
      parsed = JSON.parse(response.body)
      expect(parsed['errors'].first['detail']).to include("Couldn't find Market with 'id'=999")
    end

    it 'returns an error if the vendor does not exist' do
      market = create(:market)
      params = {market_id: market.id, vendor_id: 999}

      post "/api/v0/market_vendors/", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:not_found)
      parsed = JSON.parse(response.body)
      expect(parsed['errors'].first['detail']).to include("Couldn't find Vendor with 'id'=999")
    end
  end

  describe 'DELETE /api/v0/markets/:market_id/vendors/:vendor_id' do
    it 'deletes a market vendor' do
      market = create(:market, :with_vendor)
      vendor = market.vendors.first

      params = {market_id: market.id, vendor_id: vendor.id}

      delete "/api/v0/market_vendors/", params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:no_content)
      expect(MarketVendor.where(market_id: market.id, vendor_id: market.id).count).to eq(0)
    end

    it 'returns an error if the association does not exist' do
      params = { market_id: 123, vendor_id: 456 }

      delete '/api/v0/market_vendors', params: params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:not_found)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('errors')

      detail = parsed.dig('errors', 0, 'detail')
      expect(detail).to eq("Couldn't find MarketVendor with market_id=123 and vendor_id=456")
    end
  end
end
