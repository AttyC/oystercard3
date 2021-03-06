require_relative 'journey'

class Oystercard
  #controls the user balance

  MINIMUM_FARE = 1
  MAXIMUM_BALANCE = 90

  attr_reader :balance , :current_journey
  attr_reader :history

  def initialize(journey_class = Journey)
    @balance = 0
    @history = []
    @journey_class = journey_class
    @current_journey = @journey_class.new
  end

  def top_up(amount)
    fail_message = "cannot top-up, #{@balance + amount} is greater than limit of #{MAXIMUM_BALANCE}"
    raise fail_message if limit_exceeded?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise 'Not enough money on your card' if insufficient_funds?
    if current_journey then complete_journey end
    @current_journey = @journey_class.new
    @current_journey.origin(entry_station)
  end

  def touch_out(exit_station)
    @current_journey.destination(exit_station)
    complete_journey
  end

  def in_journey?
    !@current_journey.nil?
  end

  private

  def limit_exceeded?(amount)
    @balance + amount > MAXIMUM_BALANCE
  end

  def deduct(amount)
    @balance -= amount
  end

  def insufficient_funds?
    @balance < MINIMUM_FARE
  end

  def complete_journey
      deduct(@current_journey.fare)
      @history << @current_journey
      @current_journey = nil
  end

end
