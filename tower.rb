Hasu.load "projectile.rb"
class Tower
  SIZE = 32

  attr_reader :x, :y

  def initialize(x, y, options={})
    @x = x
    @y = y
    @cooldown = 0
    @level = 1
    @invalid = options.fetch(:invalid, false)
    @preview = options.fetch(:preview, false)
  end

  def rect
    Rect.new(
             x1: @x * SIZE,
             x2: (@x+1) * SIZE,
             y1: @y * SIZE,
             y2: (@y+1) * SIZE,
             )
  end

  def xm
    @x * SIZE + SIZE/2
  end

  def ym
    @y * SIZE + SIZE/2
  end

  def draw(window)
    draw_square(window)

    if rect.contains?(window.mouse_x, window.mouse_y)
      draw_ring(window)
    end
  end

  def draw_square(window)
    rect.draw(window, color)
  end

  def draw_ring(window)
    [
     [xm - range, ym - range],
     [xm + range, ym - range],
     [xm + range, ym + range],
     [xm - range, ym + range],
     [xm - range, ym - range],
    ].each_cons(2) do |(x1,y1),(x2,y2)|
      window.draw_line(x1, y1, Gosu::Color::GRAY, x2, y2, Gosu::Color::GRAY)
    end
  end

  def upgrade!
    @level += 1
  end
end
