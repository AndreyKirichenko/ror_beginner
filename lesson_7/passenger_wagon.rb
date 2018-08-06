require_relative 'wagon'

class PassengerWagon < Wagon
  attr_reader :taken

  def initialize(amount)
    super()
    @amount = amount
    @taken = 0
  end

  def take
    @taken += 1 if @taken < @amount
  end

  def vacate
    @taken -= 1 if @taken > 0
  end

  def available
    @amount - @taken
  end
end