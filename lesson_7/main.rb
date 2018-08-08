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
    header 'Главное меню'

    list = [
      ['Общая статистика', :common_info],
      ['Станции', :stations_menu],
      ['Поезда', :trains_menu],
      ['Маршруты', :routes_menu],
      ['Выход', :exit]
    ]

    list << ['Сгенерировать демо-данные', :seeds] unless has_seeds

    choose_in_menu list
  end

  def common_info
    clear
    header 'Общая статистика'

    @stations.each do |station|
      subheader "Станция #{station.name}"

      station.process_trains do |train|
        puts "Поезд номер: #{train.number}"
        puts "Тип поезда #{train.type}"
        puts "Вагонов #{train.wagons_amount}"
        puts ''
        puts 'Подробнее о составе:' unless train.wagons_amount.zero?

        train.process_wagons do |wagon, index|
          str = "Вагон №#{index}"
          case train.class.to_s
          when 'PassengerTrain'
            str += ", свободных мест #{wagon.available}, занято мест #{wagon.taken}, вместимость #{wagon.amount}"
          when 'CargoTrain'
            str += ", свободно #{wagon.available}, загружено #{wagon.loaded}, вместимость #{wagon.max_volume}"
          end
          puts str
        end
        puts ''
      end
      puts '', ''
    end

    continue
    main_menu
  end

  def stations_menu
    clear
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
    clear
    header 'Создание новой станции'
    puts 'Введите название для новой станции'

    name = gets.chomp

    begin
      stations << Station.new(name)
    rescue RuntimeError => e
      clear
      continue e.message
      create_station
    end

    clear
    continue "Cтанция \"#{name}\" добавлена"
    stations_menu
  end

  def all_stations
    clear
    header 'Список всех  станций'

    result = Menu.new.show(stations.map { |station| station.name })

    return if process_menu_empty result, :stations_menu, 'Список станций пуст'
    continue
    stations_menu
  end

  def choose_station(callback_method_name = nil, header = 'Выбрать станцию')
    clear
    header(header)

    index = Menu.new.ask(stations.map { |station| station.name })

    return if process_menu_empty index, :stations_menu, 'Список станций пуст'

    send(callback_method_name, index) unless callback_method_name.nil?

    index
  end

  def station_menu index
    clear
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
    clear
    stations.delete_at index
    stations_menu
  end

  def trains_at_station(index)
    clear
    header 'Список поездов на станции'

    Menu.new.show(stations[index].trains.map { |train| train.number + ' - ' + train.type })

    continue
    station_menu index
  end

  def trains_menu
    clear
    header 'Поезда'

    list = [
      ['Создать поезд', :create_train],
      ['Выбрать поезд', :choose_train, :train_menu],
      ['Посмотреть список всех поездов', :all_trains],
      ['В главное мено', :main_menu]
    ]

    choose_in_menu list
  end

  def create_train(train_class = nil)
    train_class = choose_train_type if train_class.nil?
    clear
    header 'Создание нового поезда'
    puts 'Введите номер нового поезда'

    number = gets.chomp

    begin
      trains << train_class.new(number)
    rescue RuntimeError => e
      clear
      continue e.message
      create_train train_class
    end

    clear
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
    clear
    header 'Выбор типа поезда'

    list = [
      ['Пассажирский', :passenger_train_type],
      ['Грузовой', :cargo_train_type]
    ]

    choose_in_menu list
  end

  def all_trains
    clear
    header 'Список всех существующих поездов'

    result = Menu.new.show(trains.map { |train| train.number + ' - ' + train.type })
    return if process_menu_empty result, :trains_menu, 'Список поездов пуст'
    continue

    trains_menu
  end

  def choose_train(callback_method_name = nil, header = 'Выбрать поезд')
    clear
    header(header)

    index = Menu.new.ask(trains.map { |train| train.number + ' - ' + train.type })

    return if process_menu_empty index, :trains_menu, 'Список поездов пуст'

    send(callback_method_name, index) unless callback_method_name.nil?

    index
  end

  def train_menu(index)
    clear
    train = trains[index]

    header "Поезд \"#{train.number}\""

    list = [
      ['Ехать вперед', :train_go_next, index],
      ['Ехать назад', :train_go_back, index],
      ['Прицепить вагон', :add_wagon, index],
      ['Отцепить вагон', :remove_wagon, index],
      ['Выбрать вагон', :choose_wagon, index],
      ['Удалить поезд', :remove_train, index],
      ['Вернуться в меню поездов', :trains_menu]
    ]

    choose_in_menu list
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
    header 'Добавление нового вагона'
    train = trains[index]

    max = 0
    loaded = 0

    case train.class.to_s
    when 'CargoTrain'
      puts 'Введите максимальный объем'
      max = gets.chomp.to_f
      puts 'Введите загруженность'
      loaded = gets.chomp.to_f
    when 'PassengerTrain'
      puts 'Введите число мест'
      max = gets.chomp.to_f
      puts 'Введите число пассажиров'
      loaded = gets.chomp.to_f
    end

    clear

    if train.add_wagon(max, loaded)
      continue 'Вагон добален'
    else
      continue 'Вагон не может быть добавлен'
    end
    train_menu index
  end

  def remove_wagon(index)
    clear

    train = trains[index]

    if train.remove_wagon
      continue 'Вагон отцеплен'
    else
      continue 'Вагон не может быть отцеплен'
    end
    train_menu index
  end

  def remove_train(index)
    clear
    trains.delete_at index
    continue 'Поезд удален'
    trains_menu
  end

  def choose_wagon(train_index)
    train = trains[train_index]
    amount = train.wagons.length
    clear

    if amount.zero?
      continue 'В этом поезде нет вагонов'
      train_menu train_index
    else
      header("Выберете вагон c 1 по #{amount}")
      wagon_index = gets.chomp.to_f - 1
      wagon_loading(train.wagons[wagon_index], train_index)
    end

    continue
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
    header "Укажите сколько загрузить. Доступно #{wagon.available}"

    volume = gets.chomp.to_f
    begin
      wagon.load(volume)
    rescue RuntimeError => e
      continue e.message
      cargo_wagon_loading(wagon, train_index)
    end
    train_menu train_index
  end

  def passenger_wagon_loading(wagon, train_index)
    clear
    header "Добавьте или уберите пассажира. Свободно мест #{wagon.available}"

    list = [
      ['Добавить пассажира', :passenger_wagon_take, { wagon: wagon, train_index: train_index}],
      ['Убрать пассажира', :passenger_wagon_vacate, { wagon: wagon, train_index: train_index}]
    ]

    choose_in_menu list
  end

  def passenger_wagon_take(arguments)
    begin
      arguments[:wagon].take
    rescue RuntimeError => e
      continue e.message
      passenger_wagon_loading(arguments.wagon, arguments.train_index)
    end
  end

  def passenger_wagon_vacate(arguments)
    begin
      arguments[:wagon].vacate
    rescue RuntimeError => e
      continue e.message
      passenger_wagon_loading(arguments.wagon, arguments.train_index)
    end
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

    choose_in_menu list
  end

  def all_routes
    clear
    header 'Список всех существующих маршрутов'

    result = Menu.new.show(routes.map { |route| route.name })

    return if process_menu_empty result, :routes_menu, 'Список маршрутов пуст'

    continue

    routes_menu
  end

  def create_route
    clear
    header 'Создание нового маршрута'

    station_1_index = choose_station(nil, 'Выберите станцию начала маршрута')
    return if process_menu_empty station_1_index, :routes_menu, 'Список станций пуст'

    station_2_index = choose_station(nil, 'Выберите станцию окончания маршрута')

    routes << Route.new(stations[station_1_index], stations[station_2_index])

    clear
    continue "Маршрут создан"
    routes_menu
  end

  def choose_route(callback_method_name = nil, header = 'Выбор маршрута')
    clear
    header(header)

    index = Menu.new.ask(routes.map { |route| route.name })

    return if process_menu_empty index, :routes_menu, 'Список маршрутов пуст'

    send(callback_method_name, index) unless callback_method_name.nil?
  end

  def route_menu(index)
    clear
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
    clear
    name = routes[index].name
    routes.delete_at index

    continue "Маршрут #{name} удален"
    routes_menu
  end

  def stations_in_route(index)
    clear
    header 'Список всех  станций'

    Menu.new.show(routes[index].stations.map { |station| station.name })

    continue
    route_menu index
  end

  def add_station_to_current_route(route_index)
    clear
    header 'Добавление станции в маршрут'

    station_index = choose_station(nil, 'Выберите станцию для добавления в маршрут')
    return if process_menu_empty station_index, :stations_menu, 'список станций пуст'

    route = routes[route_index]
    station = stations[station_index]

    route.add station
    clear
    continue "Станция \"#{station.name}\" добавлена к маршруту \"#{route.name}\""

    route_menu route_index
  end

  def add_train_to_current_route(route_index)
    clear
    header 'Добавление маршрута к поезду'
    train_index = choose_train
    return if process_menu_empty train_index, :routes_menu, 'Список поездов пуст'

    train = trains[train_index]

    train.route = routes[route_index]

    continue "Маршрут #{routes[route_index].name} добавлен к поезду #{train.number}"

    routes_menu
  end

  def choose_in_menu(list)
    index = Menu.new.ask(list.map { |item| item[0] })

    return if process_menu_empty index, :main_menu

    if list[index][2].nil?
      send(list[index][1])
    else
      send(list[index][1], list[index][2])
    end
  end

  def process_menu_empty(index, callback, header = 'список пуст')
    if index == -1
      clear
      continue header
      send callback
      return true
    end

    false
  end

  def seeds
    Seeds.new.generate(routes, stations, trains)
    @has_seeds = true
    clear
    continue 'Демо-данные сгенерированы'
    main_menu
  end
end

Main.new

