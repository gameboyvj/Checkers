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

  # REV: it works! good job.
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

  # REV: in the spirit of making every object do as little as possible, it's might be a good idea to keep player objects away from the board.
  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  # REV: this is a long method. You might make it shorter by combining all of the user's input into one prompt, and then converting it to an array of positions to move to/from.
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
      # REV: I think this is a place to use Integer(x) rather than x.to_i, since to_i will convert non-numbers to 0, leading to unexpected behavior, while Integer("a") would give you an argument error.
      # REV: Also, maybe String#strip would be more intuitive than gsub?
      sequence += [move.gsub(" ","").split(",").map!{|x| x.to_i}]
    end
    piece.perform_moves(sequence)
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new(ARGV.shift, ARGV.shift)
  game.run
end