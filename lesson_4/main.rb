require_relative './menu'
require_relative './route'
require_relative './station'
require_relative './cargo_train'
require_relative './passenger_train'
require_relative './seeds'

class Main
  attr_accessor :routes, :stations, :trains, :has_seeds

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @has_seeds = false

    main_menu
  end

  private

  def main_menu
    system 'clear'
    header 'Главное меню'

    list = [
      ['Станции', :stations_menu],
      ['Поезда', :trains_menu],
      ['Маршруты', :routes_menu],
      ['Выход', :exit]
    ]

    list << ['Сгенерировать демо-данные', :seeds] unless has_seeds

    choose_in_menu list
  end

  def stations_menu
    system 'clear'
    header 'Станции'

    list = [
      ['Создать станцию', :create_station],
      ['Выбрать станцию', :choose_station, :station_menu],
      ['Посмотреть список всех станций', :all_stations],
      ['В главное мено', :main_menu]
    ]

    choose_in_menu list
  end

  def create_station
    system 'clear'
    header 'Создание новой станции'
    puts 'Введите название для новой станции'

    name = gets.chomp

    stations << Station.new(name)

    system 'clear'
    continue "Cтанция \"#{name}\" добавлена"
    stations_menu
  end

  def all_stations
    system 'clear'
    header 'Список всех  станций'

    if stations.empty?
      system 'clear'
      continue 'Список станций пуст'
    else
      Menu.new.show(stations.map { |station| station.name })
      continue
    end

    stations_menu
  end

  def choose_station(callback_method_name = nil, header = 'Выбрать станцию')
    system 'clear'
    header(header)

    index = Menu.new.ask(stations.map { |station| station.name })

    send(callback_method_name, index) unless callback_method_name.nil?

    index
  end

  def station_menu index
    system 'clear'
    station = stations[index]

    header "Станция #{station.name}"

    list = [
      ['Удалить станцию', :remove_station, index],
      ['Показать все поезда на станции', :trains_at_station, index],
      ['Вернуться к меню станций', :stations_menu]
    ]

    choose_in_menu list
  end

  def remove_station(index)
    system 'clear'
    stations.delete_at index
    stations_menu
  end

  def trains_at_station(index)
    system 'clear'
    header 'Список поездов на станции'

    Menu.new.show(stations[index].trains.map { |train| train.number + ' - ' + train.type })

    continue
    station_menu index
  end

  def trains_menu
    system 'clear'
    header 'Поезда'

    list = [
      ['Создать поезд', :create_train],
      ['Выбрать поезд', :choose_train, :train_menu],
      ['Посмотреть список всех поездов', :all_trains],
      ['В главное мено', :main_menu]
    ]

    choose_in_menu list
  end

  def create_train
    system 'clear'
    header 'Создание нового поезда'
    puts 'Введите номер нового поезда'

    number = gets.chomp

    choose_train_type.new(number)

    system 'clear'
    continue "Поезд \"#{number}\" добавлен"

    trains_menu
  end

  def passenger_train_type
    PassengerTrain
  end

  def cargo_train_type
    CargoTrain
  end

  def choose_train_type
    system 'clear'
    header 'Выбор типа поезда'

    list = [
      ['Пассажирский', :passenger_train_type],
      ['Грузовой', :cargo_train_type]
    ]

    choose_in_menu list
  end

  def all_trains
    system 'clear'
    header 'Список всех существующих поездов'

    if trains.empty?
      system 'clear'
      continue 'Список поездов пуст'
    else
      Menu.new.show(trains.map { |train| train.number + ' - ' + train.type })
      continue
    end

    trains_menu
  end

  def choose_train(callback_method_name = nil, header = 'Выбрать поезд')
    system 'clear'
    header(header)

    index = Menu.new.ask(trains.map { |train| train.number + ' - ' + train.type })

    send(callback_method_name, index) unless callback_method_name.nil?

    index
  end

  def train_menu(index)
    system 'clear'
    train = trains[index]

    header "Поезд \"#{train.number}\""

    list = [
      ['Ехать вперед', :train_go_next, index],
      ['Ехать назад', :train_go_back, index],
      ['Прицепить вагон', :add_wagon, index],
      ['Отцепить вагон', :remove_wagon, index],
      ['Удалить поезд', :remove_train, index],
      ['Вернуться в меню поездов', :trains_menu]
    ]

    choose_in_menu list
  end

  def train_go_next(index)
    system 'clear'

    trains[index].go_next

    continue
    train_menu index
  end

  def train_go_back(index)
    system 'clear'

    trains[index].go_back

    continue
    train_menu index
  end

  def add_wagon(index)
    system 'clear'

    trains[index].add_wagon

    continue
    train_menu index
  end

  def remove_wagon(index)
    system 'clear'

    trains[index].remove_wagon

    continue
    train_menu index
  end

  def remove_train(index)
    system 'clear'
    trains.delete_at index
    trains_menu
  end

  def routes_menu
    system 'clear'
    header 'Маршруты'

    list = [
      ['Создать маршрут', :create_route],
      ['Выбрать маршрут', :choose_route, :route_menu],
      ['Посмотреть список всех маршрутов', :all_routes],
      ['В главное мено', :main_menu]
    ]

    choose_in_menu list
  end

  def all_routes
    system 'clear'
    header 'Список всех существующих маршрутов'

    if routes.empty?
      system 'clear'
      continue 'Список маршрутов пуст'
    else
      Menu.new.show(routes.map { |route| route.name })
      continue
    end

    routes_menu
  end

  def create_route
    system 'clear'
    header 'Создание нового маршрута'

    puts 'Введите название нового маршрута'
    name = gets.chomp

    station_1_index = choose_station(nil, 'Выберите станцию начала маршрута')
    station_2_index = choose_station(nil, 'Выберите станцию окончания маршрута')

    routes << Route.new(stations[station_1_index], stations[station_2_index])

    system 'clear'
    continue "Маршрут \"#{name}\" создан"
    routes_menu
  end

  def choose_route(callback_method_name = nil, header = 'Выбор маршрута')
    system 'clear'
    header(header)

    index = Menu.new.ask(routes.map { |route| route.name })

    send(callback_method_name, index) unless callback_method_name.nil?
  end

  def route_menu(index)
    system 'clear'
    route = routes[index]

    header "Маршрут #{route.name}"

    list = [
        ['Добавить станцию', :add_station_to_current_route, index],
        ['Список станций в маршруте', :stations_in_route, index],
        ['Добавить маршрут к поезду', :add_train_to_current_route, index],
        ['Удалить маршрут', :remove_route, index],
        ['Вернуться к меню маршрутов', :routes_menu]
    ]

    choose_in_menu list
  end

  def remove_route(index)
    system 'clear'
    name = routes[index].name
    routes.delete_at index

    continue "Маршрут #{name} удален"
    routes_menu
  end

  def stations_in_route(index)
    system 'clear'
    header 'Список всех  станций'

    Menu.new.show(routes[index].stations.map { |station| station.name })

    continue
    route_menu index
  end

  def add_station_to_current_route(route_index)
    system 'clear'
    header 'Добавление станции в маршрут'

    station_index = choose_station(nil, 'Выберите станцию для добавления в маршрут')

    route = routes[route_index]
    station = stations[station_index]

    route.add station
    system 'clear'
    continue "Станция \"#{station.name}\" добавлена к маршруту \"#{route.name}\""

    route_menu route_index
  end

  def add_train_to_current_route(route_index)
    system 'clear'
    header 'Добавление маршрута к поезду'
    train_index = choose_train

    train = trains[train_index]

    train.route = routes[route_index]

    continue "Маршрут #{routes[route_index].name} добавлен к поезду #{train.number}"
    routes_menu
  end

  def choose_in_menu(list)
    index = Menu.new.ask(list.map { |item| item[0] })

    if index.nil?
      continue 'Чтото пошло не так'
      exit
    end

    if list[index][2].nil?
      send(list[index][1])
    else
      send(list[index][1], list[index][2])
    end
  end

  def header(str = '')
    puts "==== #{str} =====", ''
  end

  def continue(str = '')
    header str unless str.empty?
    puts '', 'для прожолжения нажмите Enter'
    gets
  end

  def exit
    system 'clear'
    abort 'Досвидули!'
  end

  def seeds
    system 'clear'
    Seeds.new.generate(routes, stations, trains)

    #Я так и не понял почему тут has_seeds не виден без @
    @has_seeds = true
    continue 'Демо-данные сгенерированы'
    main_menu
  end
end

Main.new

