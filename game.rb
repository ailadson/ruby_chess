require_relative "board"
require_relative "display"

class Game
  attr_reader :current_player

  def initialize
    @board = Board.new
    @board.populate
    @display = Display.new(self, @board)
    @state = :explore
    @current_player = { :color => :black } # todo
  end

  def change_state!(pos)
    if @state == :explore
      piece = @board.at_position(pos)
      raise WrongPieceError unless @current_player[:color] == piece.color
      @board.set_potential_moves!(piece)
      @state = :move
    elsif @state == :move
      if !@board.in_check?(@current_player[:color]) && @board.castle(pos)
        @board.reset_potential_moves
        @state == :move
        change_players!
        raise CastlingException
      end
      unless @board.potential_move?(pos)
        @board.reset_potential_moves
        @state = :explore
        raise BadMoveError
      end
      unless @board.valid_move?(pos)
        @board.reset_potential_moves
        @state = :explore
        raise MovingIntoCheckError
      end
      @board.move(pos)
      @state = :explore
      change_players!
      raise CheckMateError.new("#{@current_player[:color]}") if @board.checkmate?(@current_player[:color])
      raise CheckError.new("#{@current_player[:color]}") if @board.in_check?(@current_player[:color])
    end
  end

  def change_players!
    if @current_player[:color] == :black
      @current_player[:color] = :red
    else
      @current_player[:color] = :black
    end
  end

  def play
      @display.render
      @display.update_display while(true)
  end
end

g = Game.new
g.play
