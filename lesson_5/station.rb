require_relative 'instance_counter'

class Station
  attr_reader :name

  @@instances = []
  include InstanceCounter

  def initialize(name)
    instance_count
    @@instances << self
    @trains = []
    @name = name
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
end
