class Rect
  attr_reader :x1, :x2, :y1, :y2

  def initialize(x1:0, x2:0, y1:0, y2:0)
    @x1 = x1
    @x2 = x2
    @y1 = y1
    @y2 = y2
  end

  def contains?(x, y)
    x1 < x &&
      x2 > x &&
      y1 < y &&
      y2 > y
  end

  def colliding?(other)
    other.contains?(x1, y1) ||
      other.contains?(x2, y1) ||
      other.contains?(x1, y2) ||
      other.contains?(x2, y2) ||
      contains?(other.x1, other.y1) ||
      contains?(other.x2, other.y1) ||
      contains?(other.x1, other.y2) ||
      contains?(other.x2, other.y2) ||
      aligned?(other)
  end

  def aligned?(other)
    (x1 < other.x1 && x2 > other.x1 && y1 == other.y1 && y2 == other.y2) ||
    (x1 < other.x2 && x2 > other.x2 && y1 == other.y1 && y2 == other.y2) ||
    (x1 == other.x1 && x2 == other.x2 && y1 < other.y1 && y2 > other.y1) ||
    (x1 == other.x1 && x2 == other.x2 && y1 < other.y2 && y2 > other.y2)
  end

  def draw(window, color)
    window.draw_quad(x1, y1, color, x2, y1, color, x2, y2, color, x1, y2, color)
  end
end
