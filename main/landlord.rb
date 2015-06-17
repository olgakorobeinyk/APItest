class Landlord
  attr_accessor :firstName, :lastName, :trusted, :apartments
  attr_reader :id

  def initialize(first_name, last_name, trusted=false, apartments=[])
    @firstName = first_name
    @lastName = last_name
    @trusted = trusted
    @apartments = apartments
  end

end