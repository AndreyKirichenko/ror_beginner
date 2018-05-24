# Заполнить хеш гласными буквами, где значением будет являтся порядковый номер буквы в алфавите (a - 1).

vowels = 'aeiouy'
letters = ('a'..'z').to_a

vowels_with_order = {}

letters.each_with_index do |letter, index|
  if vowels.include? letter
    vowels_with_order[letter.to_sym] = index + 1
  end
end

puts vowels_with_order
