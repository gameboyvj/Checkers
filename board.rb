class Board

  def initialize
    @board = Array.new(8){ Array.new(8){ nil } }
    setup_red
    setup_white
  end

  def [](pos)
    x,y = pos
    @board[y][x]
  end

  def []=(pos, value)
    x,y = pos
    @board[y][x] = value
  end

  def setup_red
    (0..2).each do |y|
      if y % 2 == 0
        (0..3).each do |x|
          @board[x*2+1][y] = Piece.new([x*2+1,y], :red)
        end
      else
        (0..3).each do |x|
          @board[x*2][y] = Piece.new([x*2+1,y], :red)
        end
      end
    end
  end

  def setup_white
    (5..7).each do |y|
      if y % 2 == 0
        (0..3).each do |x|
          @board[x*2][y] = Piece.new([x*2+1,y], :white)
        end
      else
        (0..3).each do |x|
          @board[x*2+1][y] = Piece.new([x*2+1,y], :white)
        end
      end
    end
  end


end