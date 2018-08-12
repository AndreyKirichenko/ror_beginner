require_relative 'instance_counter'

class Station
  include InstanceCounter

  NAME_FORMAT = /^([[:alnum:]]||\s)+$/i

  attr_reader :name

  @@instances = []

  def initialize(name)
    @name = name
    @trains = []

    validate!

    instance_count

    @@instances << self
  end

  def valid?
    validate!
  rescue RuntimeError
    false
  end

  def self.all
    return @@instances
  end

  def arrive(train)
    unless @trains.include? train
      @trains << train
    end
  end

  def departure(train)
    if @trains.include? train
      @trains.delete_if { |current_train| current_train == train }
    end
  end

  def trains(type = '')
    case type
      when 'Пассажирский'
        return @trains.select { |train| train.instance_of? PassengerTrain}

      when 'Грузовой'
        return @trains.select { |train| train.instance_of? CargoTrain}

      else
        return @trains
    end
  end

  def process_trains
    @trains.each { |train| yield(train)}
  end

  protected

  def validate!
    raise 'Вы не ввели название' if @name.empty?
    raise 'Недопустимое название' if @name !~ NAME_FORMAT
    true
  end
end
