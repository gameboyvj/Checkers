require "./board.rb"
require "./piece.rb"
require "./errors.rb"
require "colorize"

class Game

  def initialize(name1, name2)
    @board = Board.new
    @player1 = HumanPlayer.new(name1, :black, @board)
    @player2 = HumanPlayer.new(name2, :red, @board)
  end

  def run
    until @board.over?
      @board.render
      @player1.turn
      @board.render
      @player2.turn
    end
    puts "Game over #{@board.winner.to_s} wins"
  end
end

class HumanPlayer
  attr_reader :name, :color

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  def turn
    begin
      puts "#{name}, please select a piece.  Example: 0, 1"
      piece_position = gets.chomp.gsub(" ","").split(",").map!{|x| x.to_i}
      piece = @board[piece_position]
      raise WrongColorError if piece.color.nil? || piece.color != @color
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
      sequence += [move.gsub(" ","").split(",").map!{|x| x.to_i}]
    end
    piece.perform_moves(sequence)
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV.shift, ARGV.shift)
  game.run
end