require 'rails_helper'

RSpec.describe "Api::V0::Markets", type: :request do
  describe 'GET /api/v0/markets' do
    it 'returns a JSON response with all markets and vendor count' do
      markets = create_list(:market, 3, :with_vendor)

      get '/api/v0/markets'
      expect(response).to have_http_status(:success)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('data')
      expect(parsed['data']).to be_an(Array)
      expect(parsed['data'].length).to eq(3)

      first = parsed['data'].first
      expect(first).to include('attributes', 'id', 'type')

      attributes = first['attributes']
      expect(attributes).to include('name', 'street', 'city', 'county', 'state', 'zip', 'lat', 'lon', 'vendor_count')

      vendor_count = attributes['vendor_count']
      expect(vendor_count).to eq(3)
    end
  end

  describe 'GET /api/v0/markets/:id' do
    it 'returns a JSON response with a specific market by id with vendor count' do
      market = create(:market, :with_vendor)

      get "/api/v0/markets/#{market.id}"
      expect(response).to have_http_status(:success)

      parsed = JSON.parse(response.body)
      expect(parsed['data']).to include('attributes', 'id', 'type')

      data = parsed['data']
      expect(data['attributes']).to include('name', 'street', 'city', 'county','state', 'zip', 'lat', 'lon', 'vendor_count')

      attributes = data['attributes']
      expect(attributes['vendor_count']).to eq(3)
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

  describe 'GET /api/v0/markets/search' do
    context 'with valid parameters' do
      it 'returns matching markets' do
        market1 = create(:market, name: 'Market A', city: 'Anchorage', state: 'Alaska')
        market2 = create(:market, name: 'Market B', city: 'Denver', state: 'Colorado')

        get '/api/v0/markets/search', params: { state: 'Alaska' }
        expect(response).to have_http_status(:success)

        parsed = JSON.parse(response.body)
        expect(parsed).to include('data')
        expect(parsed['data']).to be_an(Array)
        expect(parsed['data'].length).to eq(1)
        expect(parsed['data'][0]['id']).to eq(market1.id.to_s)
      end

      it 'returns an empty array when no markets match' do
        get '/api/v0/markets/search', params: { state: 'California' }

        expect(response).to have_http_status(:success)

        parsed = JSON.parse(response.body)
        expect(parsed).to include('data')
        expect(parsed['data']).to be_an(Array)
        expect(parsed['data']).to be_empty
      end
    end

    context 'with invalid parameters' do
      it 'returns an error message' do
        get '/api/v0/markets/search', params: { city: 'Anchorage', name: 'Market A' }

        expect(response).to have_http_status(:unprocessable_entity)

        parsed = JSON.parse(response.body)
        expect(parsed).to include('errors')
        expect(parsed['errors'][0]['detail']).to eq('Invalid combination of parameters')
      end
    end
  end
end