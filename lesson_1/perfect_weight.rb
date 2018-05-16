puts "Ваше имя?"
name = gets.chomp
puts "Ваш рост?"
growth = gets.chomp
weight = growth.to_i - 110
if weight >= 0
  puts "#{name}, Ваш результат #{weight}"
else
  puts "Ваш вес уже оптимальный"
end

