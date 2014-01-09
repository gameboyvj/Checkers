class Piece
  attr_accessor :position, :king, :color

  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
    @king = false
  end

  def perform_slide(stop)

    possible_positions = []
    deltas = move_diffs
    deltas.each do |delta|
      possible_position = [@position[0]+delta[0], @position[1]+delta[1]]
      if is_valid?(possible_position)
        possible_positions << possible_position
      end
    end

    if possible_positions.include?(stop)
      @position = stop
      @board.move(@position, stop)
      maybe_promote?
      return true
    end

    false
  end

  def perform_jump(stop)


  end

  def move_diffs
    if @king
      [ [1, -1], [-1, -1], [1, 1], [-1, 1] ]
    elsif @color == :white
      [ [1, -1], [-1, -1] ]
    else
      [[1, 1], [-1, 1] ]
    end
  end

  def is_valid?(position)
    x, y = position
    if @board[position].nil? && x.between?(0, 7) && y.between?(0, 7)
      return true
    end
    false
  end

  def maybe_promote?
    if @color == :white && @position[1] == 0
      @king = true
    elsif @color == :black && @position[1] == 7
      @king = true
    end
  end
end