require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :loaded, :max_volume

  def initialize(max_volume, loaded = 0)
    @max_volume = max_volume
    @loaded = loaded
    @type = 'Грузовой'
  end

  def load(volume)
    if volume >= 0 && (@loaded + volume) <= @max_volume
      @loaded += volume
    else
      raise 'Вагон не должен быть перегружен'
    end
  end

  def unload
    @loaded = 0
  end

  def available
    @max_volume - @loaded
  end
end