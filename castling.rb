module Castling
  def castle(end_pos)
    return unless @active_piece.is_a?(Rook) || @active_piece.is_a?(King)
    other_piece = at_position(end_pos)
    return unless other_piece.is_a?(Rook) || other_piece.is_a?(King)
    return unless (@active_piece.first_move && other_piece.first_move)
    data = get_castle_data(@active_piece,other_piece)
    return unless data
    make_castle_move(data)
    reset_potential_moves
    true
  end

  def make_castle_move(castle_data)
    dir = castle_data[:d]
    rook = castle_data[:r]
    king = castle_data[:k]

    kx = king.position[1] + (2 * dir)
    @grid[king.position[0]][kx] = king
    @grid[king.position[0]][king.position[1]] = NullPiece.new(self, [king.position[0], king.position[1]], nil)
    king.position = [king.position[0], kx]

    rx = kx + (1 * -dir)
    @grid[rook.position[0]][rx] = rook
    @grid[rook.position[0]][rook.position[1]] = NullPiece.new(self, [rook.position[0], rook.position[1]], nil)
    rook.position = [rook.position[0], rx]

  end

  def get_castle_data(piece1, piece2)
    king = piece1.is_a?(King) ? piece1 : piece2
    rook = piece2.is_a?(Rook) ? piece2 : piece1
    x1 = king.position[1]
    x2 = rook.position[1]
    direction = (x1 > x2) ? -1 : 1

    until x1 == x2
      x1 += (1 * direction)
      next if x1 == king.position[1] || x1 == rook.position[1]
      return false unless at_position([king.position[0], x1]).is_a?(NullPiece)
    end
    {:d => direction, :k => king, :r => rook }
  end
end
