class Station
  attr_reader :name

  def initialize(name)
    @trains = []
    @name = name
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
        return @trains.select { |train| train.type == 'passenger'}

      when 'cargo'
        return @trains.select { |train| train.type == 'cargo'}

      else
        return @trains
    end
  end
end
