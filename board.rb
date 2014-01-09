require "./piece.rb"
class Board
  attr_accessor :grid
  def initialize
    @grid = Array.new(8){ Array.new(8){ nil } }
    setup_red
    setup_white
  end

  def [](pos)
    x,y = pos
    @grid[y][x]
  end

  def []=(pos, value)
    x,y = pos
    @grid[y][x] = value
  end

  def setup_red
    (0..2).each do |y|
      if y % 2 != 0
        (0..3).each do |x|
          pos = [x * 2 + 1, y]
          self[pos]= Piece.new([x * 2 + 1, y], self, :red)
          #@board[x*2+1,y] = Piece.new([x*2+1,y], :red)
          #@board[y][x*2+1] =Piece.new([x*2+1,y], :red)
        end
      else
        (0..3).each do |x|
          pos = [x * 2, y]
          self[pos] = Piece.new([x * 2, y], self, :red)
         # @board[x*2,y] = Piece.new([x*2+1,y], :red)
          #@board[y][x*2] =Piece.new([x*2,y], :red)
        end
      end
    end
    nil
  end

  def setup_white
    (5..7).each do |y|
      if y % 2 == 0
        (0..3).each do |x|
          pos = [x * 2, y]
          self[pos] = Piece.new([x*2,y], self, :white)
        end
      else
        (0..3).each do |x|
          pos = [x * 2 + 1, y]
          self[pos] = Piece.new([x * 2 + 1, y], self, :white)
        end
      end
    end
    nil
  end

  def render

    @grid.each_with_index do |row, y|
      row.each_with_index do |value, x|
        if value.nil?
          print "_ "
        elsif value.color == :red
          print "R "
        else
          print "W "
        end

      end
      puts
    end
    nil
  end

  def move (start, stop)
    piece = self[start]
    self[stop] = piece
    piece = nil

  end
end