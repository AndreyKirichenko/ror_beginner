#Прямоугольный треугольник

def check_triangle(a, b, c)
  str = "заданный треугольник - "

  result = []

  result.push "равносторонний" if equilateral? a, b, c
  result.push "равнобедренный" if isosceles? a, b, c
  result.push "прямоугольный" if rectengular? a, b, c
  result.push "разносторонний" unless result.any?

  str += result.join ", "
end

def equilateral?(a, b, c)
  a == b && a == c
end

def isosceles?(a, b, c)
  a == b || b == c || c == a
end

def rectengular?(a, b, c)
  return a**2 == b**2 + c**2 if a == [a, b, c].max
  return b**2 == a**2 + c**2 if b == [a, b, c].max
  return c**2 == a**2 + b**2 if c == [a, b, c].max
  false
end

puts "Первая сторона треугольника?"
a = gets.chomp.to_f

puts "Вторая сторона треугольника?"
b = gets.chomp.to_f

puts "Третья сторона треугольника?"
c = gets.chomp.to_f

puts check_triangle a, b,c

