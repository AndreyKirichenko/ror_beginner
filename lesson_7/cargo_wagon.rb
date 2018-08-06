require_relative 'wagon'

class CargoWagon < Wagon
  attr_reader :loaded

  def initialize(max_volume)
    @max_volume = max_volume
    @loaded = 0
    @type = 'Грузовой'
  end

  def load(volume)
    @loaded = volume if volume <= @max_volume
  end

  def unload
    @loaded = 0
  end

  def available
    @max_volume - @loaded
  end
end