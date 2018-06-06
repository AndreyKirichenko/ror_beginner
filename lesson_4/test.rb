require './station'
require './route'
require './train'

def test_route
  puts '=====================', 'Тестируем класс Route', '====================='
  puts 'Создаем маршрут с начальной и конечной станцией'
  route = Route.new Station.new('Раменское'), Station.new('Москва Казанская')
  puts '---'
  puts 'Показываем список всех станций по порядку от начальной до конечной'
  route.show
  puts '---'
  puts 'Добавляем поочередно промежуточные станции'
  route.add Station.new 'Кратово'
  route.add Station.new 'Быково'
  route.add Station.new 'Люберцы'
  route.add Station.new 'Воздухоплавательный парк'
  puts '---'
  puts 'Показываем список всех станций по порядку от начальной до конечной'
  route.show
  puts '---'
  puts 'Удаляем станцию Воздухоплавательный парк(такой нет в подмосковье)'
  route.remove_by_name 'Воздухоплавательный парк'
  puts '---'
  puts 'Показываем список всех станций по порядку от начальной до конечной'
  puts '---'
  route.show
  puts ''
  route
end

def test_train(route)
  puts '=====================', 'Тестируем класс Train', '====================='
  puts 'Создаем поезд'
  train = Train.new('Раменское - Москва', 'passenger')
  puts train, '---'
  puts "Сейчас в этом поезде вагонов #{train.wagons}", '---'
  puts 'Прицепляем вагон'
  train.add_wagon
  puts "Сейчас после прицепки в этом поезде вагонов #{train.wagons}", '---'
  puts 'Отцепляем вагон'
  train.remove_wagon
  puts "Сейчас после отцепки в этом поезде вагонов #{train.wagons}", '---'
  puts 'Отцепляем единственный оставшийся вагон - должно вывести ошибку'
  train.remove_wagon
  puts '---'
  puts "Скорость поезда #{train.speed}", '---'
  puts 'Разгонем поезд до 50'
  train.accelerate 50
  puts "Скорость поезда #{train.speed}", '---'
  puts 'Попробуем добавить и убавить по одному вагону. Должно не получиться'
  train.add_wagon
  train.remove_wagon
  puts '---', 'Остановим поезд!'
  train.stop
  puts "Скорость поезда #{train.speed}", '---'
  puts 'Назначим маршрут поезду и проверим на какой станции он находится'
  train.route = route
  puts "Поезд находится на станции #{train.station.name}", '---'
  puts 'Отправим поезд на следующую станцию'
  train.go_next
  puts "Поезд находится на станции #{train.station.name}", '---'
  puts 'Отправим поезд на предыдущую станцию'
  puts "Поезд находится на станции #{train.station.name}", '---'
  train.go_back
  puts ''
  train
end

def test_stations(route)
  puts '=====================', 'Тестируем класс Station', '====================='
  puts 'Создаем поезда и прикрепляем к ним маршрут'
  passenger_train = Train.new('Раменское - Москва', 'passenger', 1)
  freight_train = Train.new('Раменское - Москва', 'freight', 55)
  passenger_train.route = route
  freight_train.route = route
  puts '---'
  puts 'проверяем, что все поезда на первой станции'
  puts route.stations[0].trains_list, '---'
  puts 'выведем список грузовых поездов'
  puts route.stations[0].trains_list('freight'), '---'
  puts 'отправим единственный грузовой поезд и снова выведем список грузовых поездов. Убедимся что он теперь пуст!'
  freight_train.go_next
  puts route.stations[0].trains_list('freight'), '---'
  puts 'Вернем грузовой поезд назад и убедимся что он снова в списке поездов на станции'
  freight_train.go_back
  puts route.stations[0].trains_list('freight'), '---'
end

route = test_route

train = test_train route

test_stations route