require_relative 'instance_counter'

class Station
  include InstanceCounter

  NAME_FORMAT = /^([[:alnum:]]||\s)+$/i

  attr_reader :name

  @@instances = []

  def initialize(name)
    validate! name

    instance_count

    @@instances << self

    @trains = []
    @name = name
  end

  def valid?(name)
    validate! name
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
      when 'passenger'
        return @trains.select { |train| train.instance_of? PassengerTrain}

      when 'cargo'
        return @trains.select { |train| train.instance_of? CargoTrain}

      else
        return @trains
    end
  end

  protected

  def validate!(name)
    raise 'Вы не ввели название' if name.empty?
    raise 'Недопустимое название' if name !~ NAME_FORMAT
    true
  end
end
