require_relative "directional_pieces"
require_relative "slideable"
require_relative "board"

class Queen < SuperPiece
  include Slidable

  def to_s
    " \u{2654} "
  end
end
