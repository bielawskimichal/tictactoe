# frozen_string_literal: true

require_relative 'human_player'
require_relative 'computer_player'

class Game
  attr_reader :lines, :board, :current_player_id

  def initialize(player_1, player_2)
    @lines = [[1, 2, 3], [4, 5, 6], [7, 8, 9], [1, 4, 7], [2, 5, 8], [3, 6, 9], [1, 5, 9], [3, 5, 7]]
    @board = Array.new(10)
    @current_player_id = 0
    @players = [player_1.new(self, 'O'), player_2.new(self, 'X')]
    puts "#{current_player} goes first"
  end

  def play
    loop do
      place_player_marker(current_player)

      if player_has_won?(current_player)
        puts "#{current_player} wins!"
        print_board
        return
      elsif board_full?
        puts "It's a draw"
        print_board
        return
      end

      switch_players!
    end
  end

  def free_positions
    (1..9).select { |position| @board[position].nil? }
  end

  def place_player_marker(player)
    position = player.select_position!
    puts "#{player} selects position #{position}."
    @board[position] = player.marker
  end

  def board_full?
    free_positions.empty?
  end

  def player_has_won?(player)
    @lines.any? do |line|
      line.all? { |position| @board[position] == player.marker }
    end
  end

  def current_player
    @players[current_player_id]
  end

  def other_player_id
    1 - @current_player_id
  end

  def switch_players!
    @current_player_id = other_player_id
  end

  def opponent
    @players[other_player_id]
  end

  def turn_num
    10 - free_positions.size
  end

  def print_board
    vertical_divider = ' | '
    horizontal_divider = '--+---+--'

    label_for_position = ->(position) { @board[position] || position }

    row_for_display = ->(row) { row.map(&label_for_position).join(vertical_divider) }
    row_positions = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    rows_for_display = row_positions.map(&row_for_display)
    puts rows_for_display.join("\n" + horizontal_divider + "\n")
  end
end
