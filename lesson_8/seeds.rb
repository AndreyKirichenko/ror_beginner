require_relative './route'
require_relative './station'
require_relative './cargo_train'
require_relative './passenger_train'

class Seeds
  NAMES = %w[Краснодар Раменское Кратово Люберцы Выхино Новая Сортировочная
             Москва\ Казанская].freeze

  CARGO_TRAINS = 2
  PASSENGER_TRAINS = 3

  PASSENGER_WAGONS_MIN = 1
  PASSENGER_WAGONS_MAX = 5
  PASSENGER_WAGON_AMOUNT_MAX = 50

  CARGO_WAGONS_MIN = 1
  CARGO_WAGONS_MAX = 10
  CARGO_WAGON_VOLUME_MAX = 10_000

  def generate(routes = [], stations = [], trains = [])
    generate_stations(stations)
    generate_routes(routes, stations)
    generate_trains(trains)
    attach_routes(trains, routes)

    {
      routes: routes,
      stations: stations,
      trains: trains
    }
  end

  def generate_stations(stations)
    NAMES.each { |name| stations << Station.new(name) }
  end

  def generate_trains(trains)
    CARGO_TRAINS.times { trains << generate_cargo_train }
    PASSENGER_TRAINS.times { trains << generate_passenger_train }
  end

  def generate_cargo_train
    train = CargoTrain.new(generate_train_number)
    wagons_amount = rand(CARGO_WAGONS_MIN...CARGO_WAGONS_MAX)

    wagons_amount.times do
      loaded = rand(CARGO_WAGON_VOLUME_MAX)
      train.add_wagon(CARGO_WAGON_VOLUME_MAX, loaded)
    end

    train
  end

  def generate_passenger_train
    train = PassengerTrain.new(generate_train_number)
    wagons_amount = rand(PASSENGER_WAGONS_MIN...PASSENGER_WAGONS_MAX)

    wagons_amount.times do
      taken = rand(PASSENGER_WAGON_AMOUNT_MAX)
      train.add_wagon(PASSENGER_WAGON_AMOUNT_MAX, taken)
    end

    train
  end

  def generate_routes(routes, stations)
    routes << Route.new(stations[0], stations.last)
    routes << Route.new(stations[1], stations.last)

    (2..6).to_a.each { |index| routes[1].add(stations[index]) }
  end

  def attach_routes(trains, routes)
    trains.each do |train|
      case train.class.to_s
      when 'CargoTrain'
        train.route = routes[0]
      when 'PassengerTrain'
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
