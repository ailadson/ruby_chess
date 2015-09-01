require_relative "directional_pieces"
require_relative "slideable"

class Bishop < DiagonalPiece
  include Slidable

  def to_s
    " \u{265D} "
  end
end
