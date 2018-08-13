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
    @@instances
  end

  def arrive(train)
    @trains << train unless @trains.include? train
  end

  def departure(train)
    @trains.delete_if { |current_train| current_train == train }
  end

  def trains(type = '')
    case type
    when 'Пассажирский'
      @trains.select { |train| train.instance_of? PassengerTrain }

    when 'Грузовой'
      @trains.select { |train| train.instance_of? CargoTrain }

    else
      @trains
    end
  end

  def process_trains
    @trains.each { |train| yield(train) }
  end

  protected

  def validate!
    raise 'Вы не ввели название' if @name.empty?
    raise 'Недопустимое название' if @name !~ NAME_FORMAT
    true
  end
end
