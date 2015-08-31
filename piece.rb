class Piece
  attr_reader :position, :board, :color

  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
  end

  def exists?
    true
  end
end
