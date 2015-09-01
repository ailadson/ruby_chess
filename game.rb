require_relative "board"
require_relative "display"

class Game
  def initialize
    @board = Board.new
    @display = Display.new(self, @board)
    @state = :explore
    @current_player = { :color => :black } #todo
  end

  def change_state!(pos)
    if @state == :explore
      piece = @board.at_position(pos)
      raise WrongPieceError unless @current_player[:color] == piece.color
      @board.set_potential_moves!(piece)
      @state = :move
    else
      @state = :explore
    end
  end

  def play
      @display.render
      @display.update_display while(true)
  end
end

g = Game.new
g.play
