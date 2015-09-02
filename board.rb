require_relative "pieces"

class Board

  SET_UP_HASH = {
    0 => Rook,
    1 => Knight,
    2 => Bishop,
    3 => Queen,
    4 => King,
    5 => Bishop,
    6 => Knight,
    7 => Rook
  }
  attr_accessor :grid, :active_piece, :potential_moves

  def initialize
    @grid = Array.new(8){ Array.new(8) }
    @potential_moves = []
  end

  def populate
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |_, col_idx|
        populate_tile(row_idx, col_idx)
      end
    end
  end

  def populate_tile(y, x)
    if y == 1 || y == 6
      @grid[y][x] = Pawn.new(self, [y,x], set_color(y))
    elsif y == 0 || y == 7
      @grid[y][x] = SET_UP_HASH[x].new(self, [y, x], set_color(y))
    else
      @grid[y][x] = NullPiece.new(self, [y,x], nil)
    end
  end

  def set_color(y)
    return :black if y.between?(0,1)
    return :red if y.between?(6,7)
  end

  def valid_position?(pos)
    y, x = pos
    y.between?(0,7) && x.between?(0,7)
  end

  def set_potential_moves!(piece)
    validated_paths =  validate_paths(piece.get_paths, piece)
    raise NoMoveError if validated_paths.all? { |path| path.empty? }
    @potential_moves = validated_paths
    @active_piece = piece
  end

  def potential_move?(pos)
    y, x = pos
    @potential_moves.each do |path|
      path.each do |step|
        return true if step[0] == y && step[1] == x
      end
    end
    false
  end

  def valid_move?(pos)
    duped_board = self.dup
    duped_board.move(pos)
    color = duped_board.at_position(pos).color
    return false if duped_board.in_check?(color)
    true
  end

  def validate_paths(paths, piece)
    validated_paths = []
    paths.each do |path|
      validated_path = []
      path.each do |step|
        other_piece = at_position(step)
        break if other_piece.color == piece.color
        if piece.other_player?(other_piece.color)
          validated_path << step
          break
        end
        validated_path << step
      end
      validated_paths << validated_path
    end
    validated_paths
  end

  def at_position(pos)
    y, x = pos
    @grid[y][x]
  end

  def move(end_pos)
    start_y, start_x = @active_piece.position
    end_y, end_x = end_pos

    @grid[end_y][end_x] = @active_piece
    @active_piece.position = [end_y, end_x]
    @grid[start_y][start_x] = NullPiece.new(self, [start_y, start_x], nil)

    reset_potential_moves
  end

  def reset_potential_moves
    @active_piece = nil
    @potential_moves = []
  end

  def checkmate?(color)
    get_pieces_by_color(color).each do |piece|
      validated_paths = validate_paths(piece.get_paths, piece)

      validated_paths.each do |path|
        path.each do |position|

          duped_board = self.dup
          duped_board.active_piece = piece.dup(duped_board)
          duped_board.move(position.dup)
          return false unless duped_board.in_check?(color)
        end
      end
    end

    true
  end

  def in_check?(color)
    king = find_king(color)
    other_pieces = find_opposing_pieces(king)

    other_pieces.each do |piece|
      validated_paths = validate_paths(piece.get_paths, piece)

      validated_paths.each do |path|
        path.each { |pos| return true if pos == king.position }
      end
    end

    false
  end

  def find_king(color)
    get_pieces_by_color(color).each{ |piece| return piece if piece.is_a?(King) }
    raise NoKingError.new("No #{color.to_s} king")
  end

  def find_opposing_pieces(piece)
    @grid.flatten.select { |other_piece| piece.other_player?(other_piece.color) }
  end

  def get_pieces_by_color(color)
    @grid.flatten.select { |other_piece| color == other_piece.color }
  end

  def dup
    board_copy = Board.new
    board_copy.grid = self.grid.deep_dup(board_copy)
    board_copy.active_piece = @active_piece.dup(board_copy) unless @active_piece.nil?
    board_copy
  end

end

class Array
  def deep_dup(board)
    self.map{|ele| ele.is_a?(Array) ? ele.deep_dup(board) : ele.dup(board) }
  end
end

class NoKingError < StandardError
end
