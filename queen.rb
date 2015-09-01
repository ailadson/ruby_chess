require_relative "directional_pieces"
require_relative "slideable"

class Queen < SuperPiece
  include Slidable

  def to_s
    " \u{265B} "
  end
end
