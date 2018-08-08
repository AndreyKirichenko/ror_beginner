require_relative 'train'
require_relative 'cargo_wagon'

class CargoTrain < Train
  def initialize(number)
    super(number)
    @type = 'Грузовой'
  end

  def add_wagon(max_volume, loaded = 0)
    super(CargoWagon.new(max_volume, loaded))
  end
end
