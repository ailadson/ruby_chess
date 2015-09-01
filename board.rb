require_relative "pieces"

class Board
  attr_reader :grid

  def initialize
    @grid = Array.new(8){ Array.new(8) }
    @grid[3][5] = Knight.new(self,[3,5],:black)
    @potential_moves = []
    # p Rook.new(self,[1,2],:yellow).get_paths
  end

  def valid_position?(pos)
    y, x = pos
    y.between?(0,7) && x.between?(0,7)
  end

  def set_potential_moves!(piece)
    @potential_moves = piece.get_paths
  end

  def is_a_potential_move?(y,x)
    return false if @potential_moves.empty?

    @potential_moves.each do |path|
      path.each do |step|
        return true if step[0] == y && step[1] == x
      end
    end
    false
  end

  def at_position(pos)
    y, x = pos
    @grid[y][x]
  end

  def move(start, end_pos)
  end
end

Board.new
