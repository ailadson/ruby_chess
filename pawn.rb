class Pawn < Piece
  def initialize(board, position, color)
    super(board, position, color)
    set_direction
  end

  def set_direction
    y, x = position
    @direction = (@board.valid_position?([y-2,x]) ? -1 : 1)
  end

  def get_paths
    paths = []
    y, x = position
    delta = (1 * @direction)
    next_position = [y + delta,x]
    path = []
    if board.at_position(next_position).color == nil
      path << next_position
    end

    next_two_position = [y + delta + delta, x]
    if board.at_position(next_two_position).color == nil
      path << next_two_position if @first_move
    end

    paths << path
    push_capture_paths(paths)
  end

  def push_capture_paths(paths)
    push_capture_path(paths, [1,-1])
    push_capture_path(paths, [1,1])
  end

  def push_capture_path(paths, transform)
    y, x = position
    ty = y + (transform[0] * @direction)
    tx = x + transform[1]
    if board.valid_position?([ty,tx]) && other_player?(board.at_position([ty,tx]).color)
      paths << [[ty,tx]]
    end
    paths
  end

  def to_s
    " \u{265F} "
  end

end
