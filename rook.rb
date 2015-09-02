class Rook < PerpendicularPiece
  include Slidable

  def validate_special_paths
  end

  def to_s
    " \u{265C} "
  end
end
