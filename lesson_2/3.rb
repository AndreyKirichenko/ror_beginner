# 3. Заполнить массив числами фибоначчи до 100
#

fibo = [0, 1, 1]

for i in 0..100
  fibo << i if i == (fibo[-1] + fibo[-2])
end

puts fibo
