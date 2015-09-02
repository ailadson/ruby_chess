class Queen < SuperPiece
  include Slidable

  # def self.move_transforms
  #   CARDINALS + DIAGONALS
  # end

  def to_s
    " \u{265B} "
  end
end
