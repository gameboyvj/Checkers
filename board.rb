class Board
  attr_accessor :grid

  def initialize
    @grid = Array.new(8){ Array.new(8){ nil } }
    setup_red
    setup_black
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
      if y % 2 == 0
        (0..3).each do |x|
          pos = [x * 2 + 1, y]
          self[pos]= Piece.new([x * 2 + 1, y], self, :red)
        end
      else
        (0..3).each do |x|
          pos = [x * 2, y]
          self[pos] = Piece.new([x * 2, y], self, :red)
        end
      end
    end
    nil
  end

  def setup_black
    (5..7).each do |y|
      if y % 2 != 0
        (0..3).each do |x|
          pos = [x * 2, y]
          self[pos] = Piece.new([x*2,y], self, :black)
        end
      else
        (0..3).each do |x|
          pos = [x * 2 + 1, y]
          self[pos] = Piece.new([x * 2 + 1, y], self, :black)
        end
      end
    end
    nil
  end

  def render
    puts "  0 1 2 3 4 5 6 7"
    @grid.each_with_index do |row, y|
      print "#{y} "
      row.each_with_index do |value, x|
        if value.nil?
          print "_ "
        elsif value.color == :red
          print "R "
        else
          print "B "
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

  def dup
    dup_board = Board.new
    @grid.each_with_index do |row, y|
      row.each_with_index do |value, x|
        if self[[x,y]].is_a? Piece
          dup_board[[x,y]] = self[[x,y]].dup
        else
          dup_board[[x,y]] = nil
        end
      end
    end
    dup_board
  end
end