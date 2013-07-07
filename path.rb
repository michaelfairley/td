class Path
  SIZE = 32

  def self.build(start_x, start_y, directions)
    deltas = directions.scan(/./).map do |dir|
      case dir
      when 'u'; [0, -1]
      when 'd'; [0, 1]
      when 'l'; [-1, 0]
      when 'r'; [1, 0]
      else; raise
      end
    end

    deltas.reduce([Path.new(start_x, start_y)]) do |paths, delta|
      paths << Path.new(paths.last.x + delta[0], paths.last.y + delta[1])
    end
  end

  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def rect
    Rect.new(
             x1: @x * SIZE,
             x2: (@x+1) * SIZE,
             y1: @y * SIZE,
             y2: (@y+1) * SIZE,
             )
  end

  def color
    Gosu::Color::YELLOW
  end

  def xm
    @x * SIZE + SIZE/2
  end

  def ym
    @y * SIZE + SIZE/2
  end

  def draw(window)
    rect.draw(window, color)
  end
end
