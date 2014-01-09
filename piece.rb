class Piece
  attr_accessor :position, :board, :color, :king

  def initialize(position, board, color, king = false)
    @position = position
    @board = board
    @color = color
    @king = king
  end

  def perform_slide(stop)

    possible_positions = []
    deltas = move_diffs_slide
    deltas.each do |delta|
      possible_position = [@position[0] + delta[0], @position[1]+delta[1]]
      if is_valid?(possible_position)
        possible_positions << possible_position
      end
    end

    if possible_positions.include?(stop)
      make_move(stop)
      maybe_promote
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
      possible_position = [curr_x + delta[0], curr_y + delta[1]]
      adjacent_x, adjacent_y = slide_deltas[index]
      middle_position=[curr_x + adjacent_x, curr_y + adjacent_y]

      if @board[middle_position] && is_valid?(possible_position) && (@board[middle_position].color != @color)
        possible_positions << possible_position
      end
    end

    if possible_positions.include?(stop)
      middle_piece_position = get_average(@position, stop)
      make_move(stop)
      @board[middle_piece_position] = nil
      maybe_promote
      return true
    end
    false
  end

  def make_move(stop)
    @board[stop]=self
    @board[@position]=nil
    @position = stop

  end

  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      if !perform_slide(move_sequence[0])
        if !perform_jump(move_sequence[0])
          raise InvalidMoveError
        end
      end
    else
      move_sequence.each_with_index do |position, index|
        raise InvalidMoveError if !perform_jump(position)
      end
    end
  end

  def valid_move_seq?(move_sequence)

    duped_board = @board.dup
    first_piece = self.dup
    first_piece.board = duped_board
    begin
      first_piece.perform_moves!(move_sequence)
    rescue InvalidMoveError
      puts "Bad move"
      return false
    end
    true

  end

  def perform_moves(move_sequence)
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    end
  end

  def dup
    Piece.new(@position, @board, @color, @king)
  end

  private
  def get_average(start, stop)
     [(start[0] + stop[0])/2, (start[1] + stop[1])/2]
  end

  def move_diffs_slide
    if @king
      [ [1, 1], [-1, 1], [1, -1], [-1, -1] ]
    elsif @color == :black
      [ [1, -1], [-1, -1] ]
    else
      [[1, 1], [-1, 1] ]
    end
  end

  def move_diffs_jump
    if @king
      [[2, 2],[-2, 2], [2, -2], [-2, -2]]
    elsif @color == :black
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

  def maybe_promote
    if @color == :black && @position[1] == 0
      @king = true
    elsif @color == :red && @position[1] == 7
      @king = true
    end
  end
end

=begin
load 'board.rb'
b=Board.new
b[[1,2]].perform_moves([[2,3]])
b[[2,3]].perform_moves([[1,4]])
b[[5,2]].perform_moves([[6,3]])
b[[4,1]].perform_moves([[5,2]])
b[[0,5]].perform_moves([[2,3],[4,1]])
=end