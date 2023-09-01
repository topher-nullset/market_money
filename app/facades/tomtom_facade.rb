class TomtomFacade
  def initialize
    @service = TomtomService.new
  end

  def find_nearby_atms(market)
    @service.nearest_atms(market.lat, market.lon, 10000)
  end
end