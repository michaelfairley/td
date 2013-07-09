class TowerGraphics
  SIZE = Tower::SIZE
  OWNER = Tower

  def initialize(x, y, options={})
    @x1 = x
    @y1 = y
    @preview = options.fetch(:preview, false)
    @invalid = options.fetch(:invalid, false)
    @level = options.fetch(:level, 1)
  end

  def rect
    Rect.new(
             x1: @x1,
             x2: @x1 + SIZE,
             y1: @y1,
             y2: @y1 + SIZE,
             )
  end

  def xm
    @x1 + SIZE/2
  end

  def ym
    @y1 + SIZE/2
  end

  def color
    if @invalid
      Gosu::Color.argb(0xaaff0000)
    elsif @preview
      Gosu::Color.argb(0xaa0000ff)
    else
      case @level
      when 1; Gosu::Color::BLUE
      when 2; Gosu::Color::CYAN
      when 3; Gosu::Color.argb(0xffa0ffff)
      else; raise
      end
    end
  end

  def draw(window)
    rect.draw(window, color)
  end

  def draw_ring(window)
    [
     [xm - Tower::RANGE, ym - Tower::RANGE],
     [xm + Tower::RANGE, ym - Tower::RANGE],
     [xm + Tower::RANGE, ym + Tower::RANGE],
     [xm - Tower::RANGE, ym + Tower::RANGE],
     [xm - Tower::RANGE, ym - Tower::RANGE],
    ].each_cons(2) do |(x1,y1),(x2,y2)|
      window.draw_line(x1, y1, Gosu::Color::GRAY, x2, y2, Gosu::Color::GRAY)
    end
  end
end
