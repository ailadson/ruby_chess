require_relative "directional_pieces"
require_relative "steppable"

class King < SuperPiece
  include Steppable

  def to_s
    " \u{265A} "
  end
end
