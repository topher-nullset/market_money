class TomtomService

  def nearest_atms(latitude, longitude, radius)
    url = "/nearbySearch/.json?key=F5cosjYaTJaxeWoLMchIpOrGgEf498GL&lat=#{latitude}&lon=#{longitude}&radius=#{radius}&categorySet=7397"
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: 'https://api.tomtom.com/search/2/')
  end
end