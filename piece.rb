require 'debugger'
class Piece
  attr_accessor :position, :king, :color

  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
    @king = false
  end
=begin
  load 'board.rb'
  b=Board.new
  b[[1,2]].perform_slide([2,3])
  b[[3,2]].perform_jump([1,4])

=end
  def perform_slide(stop)

    possible_positions = []
    deltas = move_diffs_slide
    deltas.each do |delta|
      possible_position = [@position[0]+delta[0], @position[1]+delta[1]]
      if is_valid?(possible_position)
        possible_positions << possible_position
      end
    end

    if possible_positions.include?(stop)
      @board[stop]=self
      @board[@position]=nil
      @position = stop
      maybe_promote?
      return true
    end

    false
  end

  def perform_jump(stop)
    possible_positions = []
    jump_deltas = move_diffs_jump
    slide_deltas = move_diffs_slide
    curr_x, curr_y = @position
    jump_deltas.each_with_index do |delta, index|
      possible_position = [curr_x+delta[0], curr_y+delta[1]]
      adjacent_x, adjacent_y = slide_deltas[index]
      middle_position=[curr_x+adjacent_x, curr_y+adjacent_y]
      if @board[middle_position].nil?
      elsif is_valid?(possible_position) && @board[[curr_x+adjacent_x, curr_y+adjacent_y]].color != @color
        possible_positions << possible_position
      end
    end

    if possible_positions.include?(stop)
      @board[stop]=self
      @board[@position]=nil
      @position = stop
      maybe_promote?
      return true
    end
    false
  end

  def move_diffs_slide
    if @king
      [ [1, 1], [-1, 1], [1, -1], [-1, -1] ]
    elsif @color == :white
      [ [1, -1], [-1, -1] ]
    else
      [[1, 1], [-1, 1] ]
    end
  end

  def move_diffs_jump
    if @king
      [[2, 2],[-2, 2], [2, -2], [-2, -2]]
    elsif @color == :white
      [[2, -2], [-2, -2]]
    else
      [[2, 2],[-2, 2]]
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