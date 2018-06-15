require_relative './menu'
require_relative './route'
require_relative './station'
require_relative './cargo_train'
require_relative './passenger_train'

class Main
  attr_accessor :stations
  attr_accessor :trains
  attr_accessor :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []

    seeds
    main_menu
  end

  def main_menu
    system 'clear'
    header 'Главное меню'

    list = [
      ['Станции', :stations_menu],
      ['Поезда', :trains_menu],
      ['Маршруты', :routes_menu],
      ['Выход', :exit]
    ]

    choose_in_menu list
  end

  private

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

    Menu.new.show(stations.map { |station| station.name })

    continue ''
    stations_menu
  end

  def choose_station(callback_method_name = nil, header = 'Выбрать станцию')
    system 'clear'
    header(header)

    index = Menu.new.ask(Menu.new.show(stations.map { |station| station.name }))

    send(callback_method_name, index) unless callback_method_name.nil?
  end

  def station_menu index
    system 'clear'
    station = stations[index]

    header "Станция #{station.name}"

    list = [
      ['Удалить станцию', :remove_station, index],
      ['Вернуться к меню станций', :stations_menu]
    ]

    choose_in_menu list
  end

  def remove_station(index)
    system 'clear'
    stations.delete_at index
    stations_menu
  end

  def trains_menu
    system 'clear'
    header 'Поезда'

    list = [
      ['Создать поезд', :create_train],
      ['Выбрать поезд', :choose_train],
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

    Menu.new.show(trains.map { |train| train.number + ' - ' + train.type })

    continue ''
    trains_menu
  end

  def choose_train
    system 'clear'
    header 'Выбрать поезд'

    index = Menu.new.ask(trains.map { |train| train.number + ' - ' + train.type })

    train_menu index
  end

  def train_menu(index)
    system 'clear'
    train = trains[index]

    header "Станция #{train.number}"

    list = [
      ['Удалить поезд', :remove_train, index],
      ['Вернуться к меню поездов', :trains_menu]
    ]

    choose_in_menu list
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
      ['Выбрать маршрут', :choose_route],
      ['В главное мено', :main_menu]
    ]

    choose_in_menu list
  end

  def create_route
    system 'clear'
    header 'Создание нового маршрута'

    puts 'Введите название нового маршрута'
    name = gets.chomp

    station_1 = choose_station(nil, 'Выберите станцию начала маршрута')
    station_2 = choose_station(nil, 'Выберите станцию окончания маршрута')

    routes << Route.new(stations[station_1], stations[station_2])

    system 'clear'
    continue "Маршрут \"#{name}\" создан"
    # stations_menu
  end

  def choose_route

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

  def continue(str)
    header str unless str.empty?
    puts '', 'для прожолжения нажмите Enter'
    gets
  end

  def exit
    system 'clear'
    abort 'Досвидули!'
  end

  # def create_route
  #   puts 'В'
  # end
  #
  # def create_train
  #   # - Создавать поезда
  # end
  #
  # def add_route_to_train
  #   # - Назначать маршрут поезду
  # end
  #
  # def add_wagon
  #   # - Добавлять вагоны к поезду
  # end
  #
  # def remove_wagon
  #   # - Отцеплять вагоны от поезда
  # end
  #
  # def train_go_next
  #   # - Перемещать поезд по маршруту назад
  # end
  #
  # def train_go_back
  #   # - Перемещать поезд по маршруту назад
  # end
  #
  # # - Просматривать список станций и список поездов на станции

  def seeds
    stations << Station.new('Краснодар')
    stations << Station.new('Раменское')
    stations << Station.new('Кратово')
    stations << Station.new('Люберцы')
    stations << Station.new('Выхино')
    stations << Station.new('Новая')
    stations << Station.new('Сортировочная')
    stations << Station.new('Москва Казанская')

    trains << PassengerTrain.new('Спутник Раменское - Москва')
    trains << CargoTrain.new('Нефть Краснодар - Москва сортировочная')
  end
end

Main.new

