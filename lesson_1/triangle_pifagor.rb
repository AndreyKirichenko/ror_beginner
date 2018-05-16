#Прямоугольный треугольник

def check_triangle(a, b, c)
  str = "заданный треугольник - "

  result = Array.new

  if equilateral? a, b, c
    result.push "равносторонний"
  end

  if isosceles? a, b, c
    result.push "равнобедренный"
  end

  if rectengular? a, b, c
    result.push "прямоугольный"
  end

  unless result.any?
    result.push "разносторонний"
  end

  str += result.join ", "
end

def equilateral?(a, b, c)
  a == b && a == c
end

def isosceles?(a, b, c)
  a == b || b == c || c == a
end

def rectengular?(a, b, c)
  if a > b && a > c
    return a ** 2 == b ** 2 + c ** 2
  end

  if b > c && b > a
   return b ** 2 == a ** 2 + c ** 2
  end

  if c > a && c > b
    return c ** 2 == a ** 2 + b ** 2
  end

  false
end

puts "Первая сторона треугольника?"
a = gets.chomp.to_f

puts "Вторая сторона треугольника?"
b = gets.chomp.to_f

puts "Третья сторона треугольника?"
c = gets.chomp.to_f

puts check_triangle a, b,c

