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
