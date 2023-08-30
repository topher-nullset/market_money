require 'rails_helper'

RSpec.describe "Api::V0::Vendors", type: :request do
  describe 'GET /api/v0/vendors/:id' do
    it 'returns a JSON response with a vendors data' do
      vendors = create_list(:vendor, 5, :with_market)
      vendor = vendors.first

      get "/api/v0/vendors/#{vendor.id}"
      expect(response).to have_http_status(:success)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('data')

      data = parsed['data']
      expect(data).to include('id', 'type', 'attributes')
      expect(data['id']).to eq(vendor.id.to_s)

      attributes = data['attributes']
      expect(attributes).to include('name', 'description', 'contact_name', 'contact_phone', 'credit_accepted')

      name = attributes['name']
      expect(name).to eq(vendor.name)

      description = attributes['description']
      expect(description).to eq(vendor.description)

      relationships = data['relationships']
      expect(relationships).to include('markets')
      expect(relationships['markets']).to include('data')
      expect(relationships['markets']['data'].count).to eq(vendor.markets.count)
      expect(relationships['markets']['data'].first['id']).to eq(vendor.markets.first.id.to_s)
    end

    it 'returns a 404 error if the vendor does not exist' do
      get "/api/v0/vendors/1"
      expect(response).to have_http_status(:not_found)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('errors')
      expect(parsed['errors'].first).to include('detail')
      expect(parsed['errors'].first['detail']).to eq("Couldn't find Vendor with 'id'=1")
    end
  end
end