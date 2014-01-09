require "./board.rb"
require "./piece.rb"
require "./errors.rb"

class Game

  def initialize(name1, name2)

    @board = Board.new
    @player1 = HumanPlayer.new(name1, :black, @board)
    @player2 = HumanPlayer.new(name2, :red, @board)
    @players = {@player1 => :black, @player2 => :red}
  end

  def run

    until game_over?
      @board.render
      @player1.turn
      @board.render
      @player2.turn

    end

  end

  def game_over?
    return true if @player1.num_pieces == 0 || @player2.num_pieces == 0
    false
  end
end
=begin
load 'game.rb'
g=Game.new("v","j")
g.run
=end
class HumanPlayer
  attr_reader :name, :color, :num_pieces

  def initialize(name, color, board, num_pieces = 12)
    @name = name
    @color = color
    @board = board
    @num_pieces = num_pieces
  end

  def turn
    begin
      puts "#{name}, please select a piece    (0, 1)"
      piece_position = gets.chomp.split(", ").map!{|x| x.to_i}
      piece = @board[piece_position]
      raise WrongColorError if piece.color != @color
    rescue WrongColorError => e
        puts "Wrong color, try again"
        retry
    end
    sequence = []

    loop do
      puts "Please enter a move sequence 1 move at a time"
      puts "Enter 'd' to stop"
      move = gets.chomp
      break if move == "d"
      sequence += [move.split(", ").map!{|x| x.to_i}]
      p sequence
    end
    piece.perform_moves(sequence)
  end

end