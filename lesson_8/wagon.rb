require_relative 'manufacturer'

class Wagon
  include Manufacturer

  attr_accessor :type

  def initialize; end
end
