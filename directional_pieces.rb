require_relative "piece"

class PerpendicularPiece < Piece

  def move_transforms
    [[1,0],[-1,0],[0,1],[0,-1]]
  end

end

class DiagonalPiece < Piece
  def move_transforms
    [[1,1],[1,-1],[-1,1],[-1,-1]]
  end
end

class SuperPiece < Piece
  def move_transforms
    [[1,0],[-1,0],[0,1],[0,-1],[1,1],[1,-1],[-1,1],[-1,-1]]
  end
end
