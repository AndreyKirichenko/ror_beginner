require_relative 'instance_counter'

class Route
  include InstanceCounter

  attr_reader :first_station, :last_station

  @@instances = []

  def initialize(first_station, last_station)
    instance_count
    @first_station = first_station
    @last_station = last_station
    @intermediate = []
  end

  def add(station)
    @intermediate.push(station).uniq!(&:object_id)
  end

  def remove_by_name(station_name)
    @intermediate.delete_if { |station| station.name == station_name }
  end

  def show
    stations.each { |station| puts station.name }
  end

  def stations
    [first_station, last_station].insert(1, *@intermediate).uniq(&:object_id)
  end

  def name
    first_station.name + ' - ' + last_station.name
  end

  protected

  attr_accessor :intermediate
end
