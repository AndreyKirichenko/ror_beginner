# Класс Station (Станция):
# Имеет название, которое указывается при ее создании
# Может принимать поезда (по одному за раз)
# Может возвращать список всех поездов на станции, находящиеся в текущий момент
# Может возвращать список поездов на станции по типу (см. ниже): кол-во грузовых, пассажирских
# Может отправлять поезда (по одному за раз, при этом, поезд удаляется из списка поездов, находящихся на станции).

# require 'route'
# require 'train'

class Station
  attr_reader :name

  def initialize(name)
    @trains_list = []
    @name = name
  end

  def arrive(train)
    unless @trains_list.include? train
      @trains_list << train
    end
  end

  def departure(train)
    if @trains_list.include? train
      @trains_list.delete_if { |current_train| current_train == train }
    end
  end

  def trains_list(type = '')
    case type
      when 'passenger'
        return @trains_list.select { |train| train.type == 'passenger'}

      when 'freight'
        return @trains_list.select { |train| train.type == 'freight'}

      else
        return @trains_list
    end
  end
end
