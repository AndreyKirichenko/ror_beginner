class Train
  attr_reader :number, :route, :speed, :station, :type, :wagons

  def initialize(number, type, wagons = 0)
    @number = number
    @speed = 0
    @type = type
    @wagons = wagons
  end

  def accelerate(speed)
    @speed = speed
  end

  def stop
    @speed = 0
  end

  def add_wagon
    if speed.zero?
      @wagons += 1
    else
      puts 'Вагон не может быть добавлен. Поезд движется'
      false
    end
  end

  def remove_wagon
    unless speed.zero?
      puts 'Вагон не может быть удален. Поезд движется'
      return false
    end

    if @wagons == 0
      puts 'В поезде не осталось вагонов'
    else
      @wagons -= 1
    end
  end

  def route=(route)
    @route = route
    move_to_station route.stations[0]
  end

  def go_next
    current_index = route.stations.index @station
    next_index = current_index + 1
    if next_index >= route.stations.size
      puts 'Поезд находится на конечной станции и дальше двигаться некуда'
      false
    else
      puts "Осторожно, двери закрываются. Следующая станция #{route.stations[next_index].name}"
      move_to_station route.stations[next_index]
      true
    end
  end

  def go_back
    current_index = route.stations.index @station
    next_index = current_index - 1
    if next_index < 0
      puts 'Поезд находится на начальной станции и назад двигаться некуда'
      false
    else
      puts "Осторожно, двери закрываются. Следующая станция #{route.stations[next_index].name}"
      move_to_station route.stations[next_index]
      true
    end
  end

  private

  def move_to_station(station)
    if @station
      @station.departure self
    end

    return puts "Маршрут не задан. Движение не возможно" unless @route
    if @station == station
      puts "поезд уже находится на станции #{station.name}"
      return false
    end
    @station = station
    @station.arrive self
    true
  end
end
