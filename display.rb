
require "colorize"
require "io/console"
require_relative "errors"

class Display
  def initialize(game,board)
    @game = game
    @board = board
    @cursor_position = [0,0]
  end

  def render(message_hash = {})
    system "clear"
    render_header
    @board.grid.each_with_index do |row, idx1|
      row_string = ""
      row.each_with_index do |piece, idx2|
        row_string += colorize(piece, idx1, idx2)
      end
      puts (row_string + "|#{8-idx1}")
    end
    render_messages(message_hash)
    render_instructions
  end

  def render_instructions
    puts "Use the arrow keys to move."
    puts "Use RETURN key to select piece/move."
    puts "#{@game.current_player[:color].capitalize}'s move."
  end

  def render_messages(messages)
    if messages[:error]
      puts messages[:error].colorize(:color => :red)
    end

    if messages[:warning]
      puts messages[:warning].colorize(:color => :yellow)
    end

    if messages[:good]
      puts messages[:good].colorize(:color => :green)
    end
  end

  def render_header
    puts ("|" + ("a".."h").to_a.join("||").chomp + "|")
  end

  def colorize(piece, idx1, idx2)
    if @cursor_position == [idx1, idx2]
      colorize_tile(piece, :light_blue)
    elsif potential_move?(piece,idx1, idx2)
      colorize_tile(piece, :light_yellow)
    elsif (idx1+idx2).even?
      colorize_tile(piece, :light_white)
    else
      colorize_tile(piece, :light_black)
    end
  end

  def colorize_tile(piece, background_color)
      piece.to_s.colorize(:background => background_color, :color => piece.color)
  end

  def potential_move?(piece, idx1, idx2)
    r = @board.potential_move?([idx1,idx2])
  end

  def update_display
    c = read_char

    case c
    # when " "
    #   puts "SPACE"
    when "\r"
      begin
        @game.change_state!(@cursor_position)
        render
      rescue CastlingException
        render(:good => "You've just done a castle!")
      rescue BadCastleError => e
        render(:warning => e.message )
      rescue MovingIntoCheckError
        render(:error => "This move will put you in check!")
      rescue WrongPieceError => e
        render(:error => "Not your piece!")
      rescue BadMoveError => e
        render(:error => "Incorrect move!")
      rescue NoMoveError
        render(:warning => "No move available.")
      rescue CheckError => e
        render(:warning => "#{e.message.capitalize} is in check!!!")
      rescue CheckMateError => e
        render(:warning => "#{e.message.capitalize} is in checkmate :-(")
      end
    when "\e[A"
      new_y = @cursor_position[0] - 1
      @cursor_position[0] = new_y if @board.valid_position?([new_y, @cursor_position[1]])
      render
    when "\e[B"
      new_y = @cursor_position[0] + 1
      @cursor_position[0] = new_y if @board.valid_position?([new_y, @cursor_position[1]])
      render
    when "\e[C"
      new_x = @cursor_position[1] + 1
      @cursor_position[1] = new_x if @board.valid_position?([@cursor_position[0], new_x])
      render
    when "\e[D"
      new_x = @cursor_position[1] - 1
      @cursor_position[1] = new_x if @board.valid_position?([@cursor_position[0], new_x])
      render
    when "\u0003"
      abort
    # when /^.$/
    #   puts "SINGLE CHAR HIT: #{c.inspect}"
    # else
    #   puts "SOMETHING ELSE: #{c.inspect}"
    end
  end

  private
  def read_char
    STDIN.echo = false
    STDIN.raw!

    input = STDIN.getc.chr
    if input == "\e" then
      input << STDIN.read_nonblock(3) rescue nil
      input << STDIN.read_nonblock(2) rescue nil
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!

    return input
  end
end
