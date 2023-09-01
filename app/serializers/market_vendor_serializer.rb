class MarketVendorSerializer
  include JSONAPI::Serializer
  belongs_to :market
  belongs_to :vendor
end