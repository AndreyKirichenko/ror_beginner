#Квадратное уравнение

puts "введите a"
a = gets.chomp.to_i

puts "введите b"
b = gets.chomp.to_i

puts "введите c"
c = gets.chomp.to_i

d = b ** 2 - a * c * 4
puts "дискриминант равен #{d}"

if d < 0
  puts "корней нет"
else d >= 0
  sqrt = Math.sqrt(d)
  x1 = (-b + sqrt) / (2 * a)
  x2 = (-b - sqrt) / (2 * a)

  if x1 == x2
    puts "корни равны #{x1}"
  else
    puts "корни равны #{x1} и #{x2}"
  end
end

