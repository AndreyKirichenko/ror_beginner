module TerminalHelpers
  def clear
    system 'clear'
  end

  def header(str = '')
    header_decorator(str, '=')
    puts ''
  end

  def subheader(str = '')
    header_decorator(str, '-')
  end

  def header_decorator(str, line_char)
    line = ''
    str.length.times { line += line_char }
    puts str, line
  end

  def continue(str = '')
    header str unless str.empty?
    puts '', 'для продолжения нажмите Enter'
    gets
  end

  def exit
    system 'clear'
    abort 'Досвидули!'
  end
end