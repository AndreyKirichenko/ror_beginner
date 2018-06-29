class CargoWagon
  TYPE = 'cargo'.freeze
  attr_reader :type

  def initialize
    @type = TYPE
  end
end