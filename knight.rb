require_relative "piece"
require_relative "steppable"

class Knight < Piece
  include Steppable

  def move_transforms
    [[-2,1],[-2,-1],[-1,2],[-1,-2],[2,1],[2,-1],[1,2],[1,-2]]
  end

  def to_s
    " \u{265E} "
  end

end
