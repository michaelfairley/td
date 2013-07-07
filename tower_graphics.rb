class TowerGraphics
  SIZE = Tower::SIZE
  OWNER = Tower

  def initialize(x, y, options={})
    @x1 = x
    @y1 = y
    @preview = options.fetch(:preview, false)
    @invalid = options.fetch(:invalid, false)
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
      Gosu::Color::BLUE
    end
  end

  def draw(window)
    rect.draw(window, color)
  end

  def draw_ring(window)
    (0..2*Math::PI).step(0.01).map do |i|
      [Math.sin(i) * Tower::RANGE + xm, Math.cos(i) * Tower::RANGE + ym]
    end.each_cons(2) do |(x1,y1),(x2,y2)|
      window.draw_line(x1, y1, Gosu::Color::GRAY, x2, y2, Gosu::Color::GRAY)
    end
  end
end
