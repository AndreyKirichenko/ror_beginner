class Route
  attr_accessor :intermediate_stations
  attr_reader :first_station, :last_station

  def initialize(first_station, last_station)
    @first_station = first_station
    @last_station = last_station
    @intermediate_stations = []
  end

  def add(station)
    intermediate_stations.push(station)
  end

  def remove_by_name(station_name)
    intermediate_stations.delete_if { |station| station.name == station_name}
  end

  def show
    stations.each { |station| puts station.name }
  end

  def stations
    [first_station, last_station].insert(1, *intermediate_stations)
  end

  def name
    first_station.name + ' - ' + last_station.name
  end
end
