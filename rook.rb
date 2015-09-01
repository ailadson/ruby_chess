require_relative "directional_pieces"
require_relative "slideable"

class Rook < PerpendicularPiece
  include Slidable

  def to_s
    " \u{265C} "
  end
end
