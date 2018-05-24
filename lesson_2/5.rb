# 5. Заданы три числа, которые обозначают число, месяц, год (запрашиваем у пользователя).
# Найти порядковый номер даты, начиная отсчет с начала года. Учесть, что год может быть високосным.
# (Запрещено использовать встроенные в ruby методы для этого вроде Date#yday или Date#leap?)
# Алгоритм опредления високосного года: www.adm.yar.ru
#



def leap?(year)
  # Год високосный, если он делится на четыре без остатка, но если он делится на 100 без остатка, это не високосный год.
  # Однако, если он делится без остатка на 400, это високосный год.
  # Таким образом, 2000 г. является особым високосным годом, который бывает лишь раз в 400 лет.

  year % 4 == 0 && (year % 100 != 0 || (year % 100 == 0 && year % 400 == 0))
end

def order(day, month, year)
  months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
  months[1] = 29 if leap? year

  if month <= 0 || month > 12
    return "задана неправильная дата"
  end

  if day <= 0 || day > months[month - 1]
    return "задана неправильная дата"
  end

  days_before_this_month = 0

  i = 0
  while i < month - 1
    days_before_this_month += months[i]
    i += 1
  end

  days_before_this_month + day
end

puts "День?"
user_day = gets.chomp.to_i

puts "Месяц?"
user_month = gets.chomp.to_i

puts "Год?"
user_year = gets.chomp.to_i

puts order user_day, user_month, user_year
