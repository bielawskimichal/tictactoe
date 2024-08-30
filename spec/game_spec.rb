# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  subject(:test_game) { described_class.new(HumanPlayer, ComputerPlayer) }

  describe '#place_player_marker' do
    context 'human player selects correct position' do
      before do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        allow(h_player).to receive(:gets).once.and_return(1)
      end

      it 'changes first position to "O"' do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        board = test_game.instance_variable_get(:@board)
        expect { test_game.place_player_marker(h_player) }.to change { board[1].class }.from(NilClass).to(String)
      end
    end

    context 'human player selects 2 position and than computer player selects 1 position' do
      before do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        c_player = players[1]
        allow(h_player).to receive(:gets).once.and_return(2)
        allow(c_player).to receive(:select_position!).once.and_return(1)
      end

      it 'changes second position to "O"' do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        board = test_game.instance_variable_get(:@board)
        expect { test_game.place_player_marker(h_player) }.to change { board[2].class }.from(NilClass).to(String)
      end

      it 'changes first position to "X"' do
        players = test_game.instance_variable_get(:@players)
        c_player = players[1]
        board = test_game.instance_variable_get(:@board)
        expect { test_game.place_player_marker(c_player) }.to change { board[1].class }.from(NilClass).to(String)
      end
    end
  end

  describe '#free_positions' do
    context 'there is one empty position' do
      before do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        c_player = players[1]
        allow(h_player).to receive(:gets).exactly(5).times.and_return(1, 5, 7, 8, 6)
        5.times { test_game.place_player_marker(h_player) }
        allow(c_player).to receive(:gets).exactly(3).times.and_return(2, 3, 4)
        3.times { test_game.place_player_marker(c_player) }
      end

      it 'there is one free position' do
        expect(test_game.free_positions.length).to eq(1)
      end
    end
  end

  describe '#board_full?' do
    context 'there are no empty positions' do
      before do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        c_player = players[1]
        allow(h_player).to receive(:gets).exactly(5).times.and_return(1, 5, 7, 8, 6)
        5.times { test_game.place_player_marker(h_player) }
        allow(c_player).to receive(:gets).exactly(4).times.and_return(2, 3, 4, 9)
        4.times { test_game.place_player_marker(c_player) }
      end

      it 'returns true' do
        expect(test_game.board_full?).to be true
      end
    end

    context 'there are empty positions' do
      before do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        c_player = players[1]
        allow(h_player).to receive(:gets).exactly(5).times.and_return(1, 5, 7, 8, 6)
        5.times { test_game.place_player_marker(h_player) }
        allow(c_player).to receive(:gets).exactly(3).times.and_return(2, 3, 4)
        3.times { test_game.place_player_marker(c_player) }
      end

      it 'returns false' do
        expect(test_game.board_full?).not_to be true
      end
    end
  end

  describe '#player_has_won?' do
    context 'player places 3 markers in a horizontal row' do
      before do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        allow(h_player).to receive(:gets).exactly(3).times.and_return(1, 2, 3)
        3.times { test_game.place_player_marker(h_player) }
      end

      it 'returns true' do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        expect(test_game.player_has_won?(h_player)).to be true
      end
    end

    context 'player places 3 markers in a vertical row' do
      before do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        allow(h_player).to receive(:gets).exactly(3).times.and_return(2, 5, 8)
        3.times { test_game.place_player_marker(h_player) }
      end

      it 'returns true' do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        expect(test_game.player_has_won?(h_player)).to be true
      end
    end

    context 'player places 3 markers diagonally' do
      before do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        allow(h_player).to receive(:gets).exactly(3).times.and_return(1, 5, 9)
        3.times { test_game.place_player_marker(h_player) }
      end

      it 'returns true' do
        players = test_game.instance_variable_get(:@players)
        h_player = players[0]
        expect(test_game.player_has_won?(h_player)).to be true
      end
    end
  end

  describe '#current_player' do
    it 'is HumanPlayer' do
      players = test_game.instance_variable_get(:@players)
      h_player = players[0]
      expect(test_game.current_player).to be(h_player)
    end
  end

  describe '#other_player_id' do
    it 'is 1' do
      expect(test_game.other_player_id).to eq(1)
    end
  end

  describe '#switch_players!' do
    it 'is changes current_player_id from 0 to 1' do
      expect { test_game.switch_players! }.to change { test_game.current_player_id }.from(0).to(1)
    end
  end
end
