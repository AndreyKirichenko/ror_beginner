require_relative './route'
require_relative './station'
require_relative './cargo_train'
require_relative './passenger_train'

class Seeds
  NAMES = ['Краснодар', 'Раменское', 'Кратово', 'Люберцы', 'Выхино', 'Новая', 'Сортировочная', 'Москва Казанская']
  CARGO_TRAINS = 5
  PASSENGER_TRAINS = 10

  PASSENGER_WAGONS_MIN = 10
  PASSENGER_WAGONS_MAX = 15

  CARGO_WAGONS_MIN = 0
  CARGO_WAGONS_MAX = 500

  def generate(routes = [], stations = [], trains = [])
    generate_stations(stations)
    generate_routes(routes, stations)
    generate_trains(trains)
    attach_routes(trains, routes)

    {
      routres: routes,
      stations: stations,
      trains: trains
    }
  end

  def generate_stations(stations)
    NAMES.each { |name| stations << Station.new(name) }
  end

  def generate_trains(trains)
    CARGO_TRAINS.times { trains << generate_cargo_train }
    PASSENGER_TRAINS.times { trains << generate_passenger_train}
  end

  def generate_cargo_train
    train = CargoTrain.new(generate_train_number)
    train.add_wagon(Random.rand(CARGO_WAGONS_MIN...CARGO_WAGONS_MAX))
    train
  end

  def generate_passenger_train
    train = PassengerTrain.new(generate_train_number)
    train.add_wagon(Random.rand(PASSENGER_WAGONS_MIN...PASSENGER_WAGONS_MAX))
    train
  end

  def generate_routes(routes, stations)
    routes << Route.new(stations[0], stations.last)
    routes << Route.new(stations[1], stations.last)

    routes[1].add stations[2]
    routes[1].add stations[3]
    routes[1].add stations[4]
    routes[1].add stations[5]
    routes[1].add stations[6]
  end

  def attach_routes(trains, routes)
    trains.each do |train|
      case train.class
      when CargoTrain
        train.route = routes[0]
      when PassengerTrain
        train.route = routes[1]
      end
    end
  end

  def generate_train_number
    left = (0...3).map { ('a'..'z').to_a[rand(26)] }.join
    right = (0...2).map { ('a'..'z').to_a[rand(26)] }.join
    left + '-' + right
  end
end
