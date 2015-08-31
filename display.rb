
require "colorize"
require "io/console"

class NilClass
  def to_s
    "   "
  end

  def color

  end
end

class Display
  def initialize(board)
    @board = board
    @cursor_position = [0,0]
  end

  def render
    system "clear"
    render_header #to_do
    @board.grid.each_with_index do |row, idx1|
      row_string = ""
      row.each_with_index do |piece, idx2|
        row_string += colorize(piece, idx1, idx2) #to_do
      end
      puts (row_string + "|#{8-idx1}")
    end
    # render_instructions #to_do
  end

  def render_header
    puts ("|" + ("a".."h").to_a.join("||").chomp + "|")
  end

  def colorize(piece, idx1, idx2)

    if @cursor_position == [idx1, idx2]

      colorize_tile(piece, :yellow)

    elsif (idx1+idx2).even?

      colorize_tile(piece, :light_white)

    else

      colorize_tile(piece, :light_black)

    end

  end

  def colorize_tile(piece, background_color)
      piece.to_s.colorize(:background => background_color, :color => piece.color)
  end

  def update_display
    c = read_char

    case c
    # when " "
    #   puts "SPACE"
    # when "\r"
    #   puts "RETURN"
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
