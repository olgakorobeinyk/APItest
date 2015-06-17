class Apartment
  attr_accessor :address, :price, :square, :features, :active
  attr_reader :id

  def initialize(address, price=0, square=0, features=[], active=false)
    @address = address
    @price = price
    @square = square
    @features = features
    @active = active
  end

end