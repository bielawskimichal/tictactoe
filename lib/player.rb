# frozen_string_literal: true

class Player
  def initialize(game, marker)
    @game = game
    @marker = marker
  end
  attr_reader :marker
end
