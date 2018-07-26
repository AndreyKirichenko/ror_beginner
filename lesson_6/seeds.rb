require_relative './route'
require_relative './station'
require_relative './cargo_train'
require_relative './passenger_train'

class Seeds
  def generate(routes, stations, trains)
    stations << Station.new('Краснодар')
    stations << Station.new('Раменское')
    stations << Station.new('Кратово')
    stations << Station.new('Люберцы')
    stations << Station.new('Выхино')
    stations << Station.new('Новая')
    stations << Station.new('Сортировочная')
    stations << Station.new('Москва Казанская')

    trains << PassengerTrain.new('Спутник Раменское - Москва')
    trains << CargoTrain.new('Краснодар - Москва сортировочная')

    routes << Route.new(stations[0], stations.last)
    routes << Route.new(stations[1], stations.last)

    routes[1].add stations[2]
    routes[1].add stations[3]
    routes[1].add stations[4]
    routes[1].add stations[5]
    routes[1].add stations[6]

    trains[1].route = routes[0]
    trains[0].route = routes[1]
  end
end