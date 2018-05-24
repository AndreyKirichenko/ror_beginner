# 2. Заполнить массив числами от 10 до 100 с шагом 5

nums = []

FROM = 10
TO = 100

i = FROM

while i <= TO
  nums.push i
  i += 5
end

puts nums
