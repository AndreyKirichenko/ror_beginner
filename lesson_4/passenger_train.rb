require_relative 'train'
require_relative 'passenger_wagon'

class PassengerTrain < Train
  def initialize(number)
    super(number)
    @type = 'passenger'
  end

  def add_wagon
    super(PassengerWagon.new)
  end
end