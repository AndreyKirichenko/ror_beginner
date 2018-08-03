require_relative 'train'
require_relative 'cargo_wagon'


class CargoTrain < Train
  def initialize(number)
    super(number)
    @type = 'Грузовой'
  end

  def add_wagon
    super(CargoWagon.new)
  end
end