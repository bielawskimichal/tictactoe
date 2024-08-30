# frozen_string_literal: true

require_relative 'player'
require_relative 'game'

class ComputerPlayer < Player
  DEBUG = true

  def group_positions_by_markers(line)
    markers = line.group_by { |position| @game.board[position] }
    markers.default = []
    markers
  end

  def select_position!
    opponent_marker = @game.opponent.marker

    winning_or_blocking_position = look_for_winning_or_blocking_position(opponent_marker)
    return winning_or_blocking_position if winning_or_blocking_position

    return corner_trap_defense_position(opponent_marker) if corner_trap_defense_needed?

    random_prioritized_position
  end

  def look_for_winning_or_blocking_position(opponent_marker)
    for line in @game.lines
      markers = group_positions_by_markers(line)
      next if markers[nil].length != 1

      if markers[marker].length == 2
        log_debug "winning on line #{line.join}"
        return markers[nil].first
      elsif markers[opponent_marker].length == 2
        log_debug "coul @lines,d block on line #{line.join}"
        blocking_position = markers[nil].first
      end
end
    return unless blocking_position

    log_debug "blocking at #{blocking_position}"
    blocking_position
  end

  def corner_trap_defense_needed?
    corner_positions = [1, 3, 7, 9]
    opponent_chose_a_corner = corner_positions.any? { |pos| !@game.board[pos].nil? }
    @game.turn_num == 2 && opponent_chose_a_corner
  end

  def corner_trap_defense_position(opponent_marker)
    log_debug 'defending against corner start by playing adjacent'
    opponent_position = @game.board.find_index { |marker| marker == opponent_marker }
    safe_responses = { 1 => [2, 4], 3 => [2, 6], 7 => [4, 8], 9 => [6, 8] }
    safe_responses[opponent_position].sample
  end

  def random_prioritized_position
    log_debug 'picking random position, favoring center and then corners'
    ([5] + [1, 3, 7, 9].shuffle + [2, 4, 6, 8].shuffle).find do |pos|
      @game.free_positions.include?(pos)
    end
  end

  def log_debug(message)
    puts "#{self}: #{message}" if DEBUG
  end

  def to_s
    "Computer #{@game.current_player_id}"
  end
end
