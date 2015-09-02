class Piece

  attr_reader :board, :color
  attr_accessor :position

  def initialize(board, position, color)
    @board = board
    @position = position
    @color = color
    @first_move = true
  end

  def exists?
    true
  end

  def other_player?(check_color)
    color != check_color && check_color != nil
  end

  def dup(board)
    self.class.new(board, position.dup, color)
  end

  def position=(pos)
    @first_move = false
    @position = pos
  end

  def validate_special_path
    false
  end
end
