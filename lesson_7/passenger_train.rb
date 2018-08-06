require_relative 'train'
require_relative 'passenger_wagon'

class PassengerTrain < Train
  def initialize(number)
    super(number)
    @type = 'Пассажирский'
  end

  def add_wagon(amount)
    super(PassengerWagon.new(amount))
  end
end
