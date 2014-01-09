require "./board.rb"
require "./piece.rb"
require "./errors.rb"

class Game

  def initialize(player1, player2)
    @player1 = HumanPlayer.new(:black)
    @player2 = HumanPlayer.new(:red)
    @players = {@player1 => :black, @player2 => :red}
    @board = Board.new
  end

  def run

    until game_over?
      player1.turn
      player2.turn

    end

  end

  def game_over?
    return true if @player1.num_pieces == 0 || @player2.num_pieces == 0
    false
  end
end

class HumanPlayer
  attr_reader :name, :color, :num_pieces

  def initialize(name, color, num_pieces = 12)
    @name = name
    @color = color
    @num_pieces = num_pieces
  end

  def turn
    puts "Please select a piece 0, 1"
    piece_position = gets.chomp.to_a
    piece = @board[piece_position]
    move = "a"
    sequence = []
    loop do
      puts "Please enter a move sequence 1 move at a time"
      puts "Enter 'd' to stop"
      move = gets.chomp
      break if move == "d"
      sequence += [move.to_a]
    end
    piece.perform_moves(sequence)
  end

end