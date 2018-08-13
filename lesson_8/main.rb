require_relative './terminal_helpers'
require_relative './menu'
require_relative './route'
require_relative './station'
require_relative './cargo_train'
require_relative './passenger_train'
require_relative './seeds'

class Main
  include TerminalHelpers
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
    clear
    header('Главное меню')

    list = main_menu_list
    list << ['Сгенерировать демо-данные', :seeds] unless has_seeds

    choose_in_menu(list)
  end

  def main_menu_list
    [
      ['Общая статистика', :common_info],
      ['Станции', :stations_menu],
      ['Поезда', :trains_menu],
      ['Маршруты', :routes_menu],
      ['Выход', :exit]
    ]
  end

  def common_info
    clear
    header('Общая статистика')

    common_info_stations

    continue
    main_menu
  end

  def common_info_stations
    @stations.each do |station|
      sub_header("Станция #{station.name}")

      common_info_station(station)
    end
  end

  def common_info_station(station)
    station.process_trains do |train|
      common_info_train(train.number, train.type, train.wagons_amount)

      train.process_wagons do |wagon, index|
        common_info_wagon(wagon, index)
      end
      puts ''
    end
    puts '', ''
  end

  def common_info_train(number, type, wagons_amount)
    puts "Поезд номер: #{number}"
    puts "Тип поезда #{type}"
    puts "Вагонов #{wagons_amount}"
    puts ''
    puts 'Подробнее о составе:' unless wagons_amount.zero?
  end

  def common_info_wagon(wagon, index)
    str = "Вагон №#{index + 1}"
    case wagon.class.to_s
    when 'CargoWagon'
      common_info_wagon_cargo(wagon.available, wagon.loaded, wagon.max_volume)
    when 'PassengerWagon'
      common_info_wagon_passenger(wagon.available, wagon.taken, wagon.amount)
    end
    puts str
  end

  def common_info_wagon_cargo(available, loaded, max_volume)
    ", свободно #{available}, загружено #{loaded}, вместимость #{max_volume}"
  end

  def common_info_wagon_passenger(available, taken, amount)
    ", свободных мест #{available}, занято мест #{taken}, вместимость #{amount}"
  end

  def stations_menu
    clear
    header('Станции')

    list = [
      ['Создать станцию', :create_station],
      ['Выбрать станцию', :choose_station, :station_menu],
      ['Посмотреть список всех станций', :all_stations],
      ['В главное мено', :main_menu]
    ]

    choose_in_menu list
  end

  def create_station
    clear
    header('Создание новой станции')
    puts 'Введите название для новой станции'

    name = gets.chomp
    try_create_station(name)

    clear
    continue("Станция \"#{name}\" добавлена")
    stations_menu
  end

  def try_create_station(name)
    stations << Station.new(name)
  rescue RuntimeError => e
    clear
    continue(e.message)
    create_station
  end

  def all_stations
    clear
    header('Список всех станций')

    result = Menu.new.show(stations.map(&:name))

    return if process_empty_menu result, :stations_menu, 'Список станций пуст'
    continue
    stations_menu
  end

  def choose_station(callback_method_name = nil, header = 'Выбрать станцию')
    clear
    header(header)

    index = Menu.new.ask(stations.map(&:name))

    return if process_empty_menu index, :stations_menu, 'Список станций пуст'

    send(callback_method_name, index) unless callback_method_name.nil?

    index
  end

  def station_menu(index)
    clear
    station = stations[index]

    header("Станция #{station.name}")

    choose_in_menu(station_menu_list(index))
  end

  def station_menu_list(index)
    [
      ['Удалить станцию', :remove_station, index],
      ['Показать все поезда на станции', :trains_at_station, index],
      ['Вернуться к меню станций', :stations_menu]
    ]
  end

  def remove_station(index)
    clear
    stations.delete_at(index)
    stations_menu
  end

  def trains_at_station(index)
    clear
    header 'Список поездов на станции'

    trains = stations[index].trains

    Menu.new.show(trains.map { |train| train.number + ' - ' + train.type })

    continue
    station_menu(index)
  end

  def trains_menu
    clear
    header('Поезда')

    choose_in_menu(trains_menu_list)
  end

  def trains_menu_list
    [
      ['Создать поезд', :create_train],
      ['Выбрать поезд', :choose_train, :train_menu],
      ['Посмотреть список всех поездов', :all_trains],
      ['В главное мено', :main_menu]
    ]
  end

  def create_train(train_class = nil)
    train_class = choose_train_type if train_class.nil?
    clear
    header('Создание нового поезда')
    puts 'Введите номер нового поезда'

    number = gets.chomp

    try_create_train(train_class)

    clear
    continue("Поезд \"#{number}\" добавлен")

    trains_menu
  end

  def try_create_train(train_class)
    trains << train_class.new(number)
  rescue RuntimeError => e
    clear
    continue(e.message)
    create_train(train_class)
  end

  def passenger_train_type
    PassengerTrain
  end

  def cargo_train_type
    CargoTrain
  end

  def choose_train_type
    clear
    header('Выбор типа поезда')

    choose_in_menu(choose_train_type_list)
  end

  def choose_train_type_list
    [
      ['Пассажирский', :passenger_train_type],
      ['Грузовой', :cargo_train_type]
    ]
  end

  def all_trains
    clear
    header('Список всех существующих поездов')

    data = trains.map { |train| train.number + ' - ' + train.type }

    result = Menu.new.show(data)
    return if process_empty_menu(result, :trains_menu, 'Список поездов пуст')
    continue

    trains_menu
  end

  def choose_train(callback_method_name = nil, header = 'Выбрать поезд')
    clear
    header(header)

    data = trains.map { |train| train.number + ' - ' + train.type }

    index = Menu.new.ask(data)

    return if process_empty_menu(index, :trains_menu, 'Список поездов пуст')

    send(callback_method_name, index) unless callback_method_name.nil?

    index
  end

  def train_menu(index)
    clear
    train = trains[index]

    header("Поезд \"#{train.number}\"")

    choose_in_menu(train_menu_list(index))
  end

  def train_menu_list(index)
    [
      ['Ехать вперед', :train_go_next, index],
      ['Ехать назад', :train_go_back, index],
      ['Прицепить вагон', :add_wagon, index],
      ['Отцепить вагон', :remove_wagon, index],
      ['Выбрать вагон', :choose_wagon, index],
      ['Удалить поезд', :remove_train, index],
      ['Вернуться в меню поездов', :trains_menu]
    ]
  end

  def train_go_next(index)
    clear

    train = trains[index]

    if train.go_next
      continue 'Осторожно, двери закрываются'
    else
      continue 'Поезд не может ехать дальше'
    end

    train_menu index
  end

  def train_go_back(index)
    clear

    train = trains[index]

    if train.go_back
      continue 'Осторожно, двери закрываются'
    else
      continue 'Поезд не может ехать дальше'
    end

    train_menu index
  end

  def add_wagon(index)
    clear
    header('Добавление нового вагона')
    train = trains[index]
    options = get_wagon_options(train)

    if train.add_wagon(options[:max], options[:loaded])
      continue('Вагон добален')
    else
      continue('Вагон не может быть добавлен')
    end
    train_menu(index)
  end

  def get_wagon_options(train)
    clear
    case train.class.to_s
    when 'CargoTrain'
      cargo_wagon_options
    when 'PassengerTrain'
      passenger_wagon_options
    end
  end

  def cargo_wagon_options
    puts 'Введите максимальный объем'
    max = gets.chomp.to_f
    puts 'Введите загруженность'
    loaded = gets.chomp.to_f

    {
      max: max,
      loaded: loaded
    }
  end

  def passenger_wagon_options
    puts 'Введите число мест'
    max = gets.chomp.to_f
    puts 'Введите число пассажиров'
    loaded = gets.chomp.to_f

    {
      max: max,
      loaded: loaded
    }
  end

  def remove_wagon(index)
    clear

    train = trains[index]

    if train.remove_wagon
      continue('Вагон отцеплен')
    else
      continue('Вагон не может быть отцеплен')
    end
    train_menu(index)
  end

  def remove_train(index)
    clear
    trains.delete_at(index)
    continue('Поезд удален')
    trains_menu
  end

  def choose_wagon(train_index)
    train = trains[train_index]
    amount = train.wagons.length

    clear

    if amount.zero?
      continue 'В этом поезде нет вагонов'
      train_menu(train_index)
    else
      wagon_loading(train.wagons[choose_wagon_by_number(amount)], train_index)
    end

    continue
  end

  def choose_wagon_by_number(amount)
    header("Выберете вагон c 1 по #{amount}")
    gets.chomp.to_f - 1
  end

  def wagon_loading(wagon, train_index)
    clear
    case wagon.class.to_s
    when 'CargoWagon'
      cargo_wagon_loading(wagon, train_index)
    when 'PassengerWagon'
      passenger_wagon_loading(wagon, train_index)
    end
  end

  def cargo_wagon_loading(wagon, train_index)
    clear
    header("Укажите сколько загрузить. Доступно #{wagon.available}")

    volume = gets.chomp.to_f
    begin
      wagon.load(volume)
    rescue RuntimeError => e
      continue(e.message)
      cargo_wagon_loading(wagon, train_index)
    end
    train_menu(train_index)
  end

  def passenger_wagon_loading(wagon, index)
    clear
    header "Добавьте или уберите пассажира. Свободно мест #{wagon.available}"

    list = [
      ['Добавить', :passenger_wagon_take, { wagon: wagon, train_index: index }],
      ['Убрать', :passenger_wagon_vacate, { wagon: wagon, train_index: index }]
    ]

    choose_in_menu(list)
  end

  def passenger_wagon_take(arguments)
    arguments[:wagon].take
  rescue RuntimeError => e
    continue(e.message)
    passenger_wagon_loading(arguments.wagon, arguments.train_index)
  end

  def passenger_wagon_vacate(arguments)
    arguments[:wagon].vacate
  rescue RuntimeError => e
    continue(e.message)
    passenger_wagon_loading(arguments.wagon, arguments.train_index)
  end

  def routes_menu
    clear
    header 'Маршруты'

    list = [
      ['Создать маршрут', :create_route],
      ['Выбрать маршрут', :choose_route, :route_menu],
      ['Посмотреть список всех маршрутов', :all_routes],
      ['В главное мено', :main_menu]
    ]

    choose_in_menu(list)
  end

  def all_routes
    clear
    header('Список всех существующих маршрутов')

    result = Menu.new.show(routes.map(&:name))

    return if process_empty_menu(result, :routes_menu, 'Список маршрутов пуст')

    continue

    routes_menu
  end

  def create_route
    clear
    header 'Создание нового маршрута'

    options = choose_stations_for_new_route
    routes << Route.new(options[:station_1], options[:station_2])

    clear
    continue 'Маршрут создан'
    routes_menu
  end

  def choose_stations_for_new_route
    index1 = choose_station(nil, 'Выберите станцию начала маршрута')
    return if process_empty_menu(index1, :routes_menu, 'Список станций пуст')
    index2 = choose_station(nil, 'Выберите станцию окончания маршрута')

    {
      station_1: stations[index1],
      station_2: stations[index2]
    }
  end

  def choose_route(callback_method_name = nil, header = 'Выбор маршрута')
    clear
    header(header)

    index = Menu.new.ask(routes.map(&:name))

    return if process_empty_menu index, :routes_menu, 'Список маршрутов пуст'

    send(callback_method_name, index) unless callback_method_name.nil?
  end

  def route_menu(index)
    clear
    route = routes[index]

    header("Маршрут #{route.name}")
    choose_in_menu(route_menu_list)
  end

  def route_menu_list
    [
      ['Добавить станцию', :add_station_to_current_route, index],
      ['Список станций в маршруте', :stations_in_route, index],
      ['Добавить маршрут к поезду', :add_train_to_current_route, index],
      ['Удалить маршрут', :remove_route, index],
      ['Вернуться к меню маршрутов', :routes_menu]
    ]
  end

  def remove_route(index)
    clear
    name = routes[index].name

    routes.delete_at(index)

    continue("Маршрут #{name} удален")
    routes_menu
  end

  def stations_in_route(index)
    clear
    header('Список всех станций')

    Menu.new.show(routes[index].stations.map(&:name))

    continue
    route_menu(index)
  end

  def add_station_to_current_route(route_index)
    clear
    header('Добавление станции в маршрут')

    index = choose_station(nil, 'Выберите станцию для добавления в маршрут')
    return if process_empty_menu(index, :stations_menu, 'список станций пуст')

    route = routes[route_index]
    station = stations[index]

    route.add(station)
    clear
    continue("Станция \"#{station.name}\" добавлена к \"#{route.name}\"")

    route_menu(route_index)
  end

  def add_train_to_current_route(route_index)
    clear
    header('Добавление маршрута к поезду')
    index = choose_train
    return if process_empty_menu(index, :routes_menu, 'Список поездов пуст')

    train = trains[index]

    train.route = routes[route_index]

    route_name = routes[route_index].name

    continue("Маршрут #{route_name} добавлен к поезду #{train.number}")

    routes_menu
  end

  def choose_in_menu(list)
    index = Menu.new.ask(list.map { |item| item[0] })

    return if process_empty_menu(index, :main_menu)

    process_list(list, index)
  end

  def process_list(list, index)
    if list[index][2].nil?
      send(list[index][1])
    else
      send(list[index][1], list[index][2])
    end
  end

  def process_empty_menu(index, callback, header = 'список пуст')
    if index == -1
      clear
      continue(header)
      send(callback)
      return true
    end

    false
  end

  def seeds
    Seeds.new.generate(routes, stations, trains)
    @has_seeds = true
    clear
    continue('Демо-данные сгенерированы')
    main_menu
  end
end

Main.new
