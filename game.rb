require_relative "board"
require_relative "display"

class Game
  def initialize
    @board = Board.new
    @display = Display.new(@board)
  end

  def play
      @display.render
      @display.update_display while(true)
  end
end

g = Game.new
g.play
