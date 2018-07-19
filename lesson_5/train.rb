class Train
  attr_reader :number, :route, :speed, :station, :type, :wagons

  def initialize(number)
    @number = number
    @speed = 0
    @wagons = []
  end

  def accelerate(speed)
    @speed = speed
  end

  def stop
    @speed = 0
  end

  def add_wagon(wagon = '')
    if speed.zero?
      @wagons.push wagon
      true
    else
      false
    end
  end

  def remove_wagon
    unless speed.zero?
      return false
    end

    unless @wagons.size.zero?
      @wagons.pop
      return true
    end

    false
  end

  def route=(route)
    @route = route
    move_to_station route.stations[0]
  end

  def go_next
    current_index = route.stations.index @station
    next_index = current_index + 1

    if next_index >= route.stations.size
      false
    else
      move_to_station route.stations[next_index]
      true
    end
  end

  def go_back
    current_index = route.stations.index @station
    next_index = current_index - 1

    if next_index < 0
      false
    else
      move_to_station route.stations[next_index]
      true
    end
  end

  private

  def move_to_station(station)
    if @station
      @station.departure self
    end

    return false unless @route

    if @station == station
      return false
    end

    @station = station
    @station.arrive self

    true
  end
end
