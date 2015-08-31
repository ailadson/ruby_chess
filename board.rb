require_relative "queen"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8){ Array.new(8) }
    @grid[0][5] = Queen.new(self,[0,5],:black)
  end

  def valid_position?(pos)
    y, x = pos
    y.between?(0,7) && x.between?(0,7)
  end

  def move(start, end_pos)
  end
end
