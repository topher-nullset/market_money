class Atm
  attr_reader :name, :address, :distance

  def initialize(data)
    @name = data['poi']['name']
    @address = data['address']['freeformAddress']
    @distance = data['dist']
  end
end
