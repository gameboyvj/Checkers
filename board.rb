class Board
  attr_accessor :grid
  attr_reader :winner
  def initialize
    @grid = Array.new(8){ Array.new(8){ nil } }
    setup_red
    setup_black
    @winner = nil
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
    puts "   #{(0..7).to_a.join("  ")}"
    @grid.each_with_index do |row, y|
      print "#{y} "
      y % 2 == 0 ? color = :light_white : color = :light_black
      row.each_with_index do |value, x|
        color == :light_white ? color = :light_black : color = :light_white
        if value.nil?
          print "   ".colorize(:background => color)
        elsif value.color == :red
          print " \u25CF ".encode.colorize(:color =>:red, :background => color)
        else
          print " \u25CF ".encode.colorize(:background => color)
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

  def over?
    if @grid.flatten.compact.all? {|piece| piece.color == :red}
      winner = :red
      return true
    end
    if @grid.flatten.compact.all? {|piece| piece.color == :black}
      winner = :black
    end
    false
  end
end