# frozen_string_literal: true

require_relative 'lib/game'

players_with_human = [HumanPlayer, ComputerPlayer].shuffle
Game.new(*players_with_human).play
