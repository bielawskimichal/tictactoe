# frozen_string_literal: true

require_relative 'player'

class HumanPlayer < Player
  def select_position!
    @game.print_board
    loop do
      print "Select your #{marker} position: "
      selection = gets.to_i
      return selection if @game.free_positions.include?(selection)

      puts "Position #{selection} is not available. Try again."
    end
  end

  def to_s
    'Human'
  end
end
