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

      markets_data = relationships['markets']['data']
      expect(markets_data.count).to eq(vendor.markets.count)
      expect(markets_data.first['id']).to eq(vendor.markets.first.id.to_s)
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

  describe 'POST /api/v0/vendors/' do
    it 'creates a new vendor' do
      vendor_params = {
        name: 'Buzzy Bees',
        description: 'local honey and wax products',
        contact_name: 'Berly Couwer',
        contact_phone: '8389928383',
        credit_accepted: false
      }

      post '/api/v0/vendors', params: vendor_params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:created)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('data')

      data = parsed['data']
      expect(data).to include('id', 'type', 'attributes')

      attributes = data['attributes']
      expect(attributes).to include(
        'name' => 'Buzzy Bees',
        'description' => 'local honey and wax products',
        'contact_name' => 'Berly Couwer',
        'contact_phone' => '8389928383',
        'credit_accepted' => false
      )
    end

    it 'returns an error if vendor creation fails' do
      invalid_vendor_params = {
        name: '', # Invalid name
        description: '', # Invalid description
        contact_name: 'John Doe',
        contact_phone: '1234567890',
        credit_accepted: true
      }

      post '/api/v0/vendors', params: invalid_vendor_params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:bad_request)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('errors')

      errors = parsed['errors']
      expect(errors.first).to include('detail')

      detail = errors.first['detail']
      expect(detail).to eq("Name can't be blank, Description can't be blank")
    end
  end

  describe 'PATCH /api/v0/vendors/:id' do
    it 'updates an existing vendor' do
      vendor = create(:vendor, :with_market)

      vendor_params = {
        name: 'Buzzy Bees',
        description: 'local honey and wax products',
        contact_name: 'Berly Couwer',
        contact_phone: '8389928383',
        credit_accepted: true
      }

      patch "/api/v0/vendors/#{vendor.id}", params: vendor_params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:success)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('data')

      data = parsed['data']
      expect(data).to include('id', 'type', 'attributes')
      expect(data['id']).to eq(vendor.id.to_s)

      attributes = data['attributes']
      expect(attributes).to include(
        'name' => 'Buzzy Bees',
        'description' => 'local honey and wax products',
        'contact_name' => 'Berly Couwer',
        'contact_phone' => '8389928383',
        'credit_accepted' => true
      )
    end

    it 'returns an error if vendor update fails because vendor id doesnt exist' do
      vendor_params = {
        name: 'Buzzy Bees',
        description: 'local honey and wax products',
        contact_name: 'Berly Couwer',
        contact_phone: '8389928383',
        credit_accepted: true
      }

      patch "/api/v0/vendors/1", params: vendor_params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:not_found)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('errors')
      expect(parsed['errors'].first).to include('detail')
      expect(parsed['errors'].first['detail']).to eq("Couldn't find Vendor with 'id'=1")
    end

    it 'returns an error if the user sends invalid data' do
      vendor = create(:vendor, :with_market)
      vendor_params = {
        name: 'Buzzy Bees',
        description: 'local honey and wax products',
        contact_name: '',
        contact_phone: '999999999999999999999',
        credit_accepted: true
      }

      patch "/api/v0/vendors/#{vendor.id}", params: vendor_params.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
      expect(response).to have_http_status(:bad_request)

      parsed = JSON.parse(response.body)
      expect(parsed).to include('errors')
      expect(parsed['errors'].first).to include('detail')
      expect(parsed['errors'].first['detail']).to eq("Contact name can't be blank, Contact phone is too long (maximum is 15 characters)")
    end
  end

  describe 'DELETE /api/v0/vendors/:id' do
    it 'deletes the vendor' do
      vendor = create(:vendor)

      delete "/api/v0/vendors/#{vendor.id}"
      expect(response).to have_http_status(:no_content)
      expect(Vendor.exists?(vendor.id)).to be_falsey
    end

    it 'returns an error if the vendor does not exist' do
      delete "/api/v0/vendors/999"
      expect(response).to have_http_status(:not_found)
      
      parsed = JSON.parse(response.body)
      expect(parsed['errors'].first['detail']).to include("Couldn't find Vendor with 'id'=999")
    end
  end
end