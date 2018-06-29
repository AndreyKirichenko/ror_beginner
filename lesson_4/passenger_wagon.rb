class PassengerWagon
  TYPE = 'passenger'.freeze
  attr_reader :type

  def initialize
    @type = TYPE
  end
end