require_relative 'instance_counter'

class Route
  attr_reader :first_station, :last_station
  @@instances = []

  include InstanceCounter

  def initialize(first_station, last_station)
    instance_count
    @first_station = first_station
    @last_station = last_station
    @intermediate_stations = []
  end

  def add(station)
    intermediate_stations.push(station).uniq! { |station| station.object_id }
  end

  def remove_by_name(station_name)
    intermediate_stations.delete_if { |station| station.name == station_name}
  end

  def show
    stations.each { |station| puts station.name }
  end

  def stations
    [first_station, last_station].insert(1, *intermediate_stations).uniq { |station| station.object_id }
  end

  def name
    first_station.name + ' - ' + last_station.name
  end

  private

  attr_accessor :intermediate_stations
end
