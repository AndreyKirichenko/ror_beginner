class Menu
  def ask(list)
    show list

    inputed_index = gets.chomp.to_i - 1

    if inputed_index < 0 || inputed_index > list.size - 1
      puts '', 'Попробуйте еще раз', ''
      ask list
    end

    return inputed_index
  end

  def show(list)
    list.each_index do |index|
      puts "#{index + 1} - #{list[index]}"
    end
  end
end