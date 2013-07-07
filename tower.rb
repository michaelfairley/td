Hasu.load "projectile.rb"

class Tower
  SIZE = 32
  RANGE = 100
  FIRE_RATE = 20

  def initialize(x, y)
    @x = x
    @y = y
    @cooldown = 0
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

  def color
    Gosu::Color::BLUE
  end

  def draw(window)
    rect.draw(window, color)

    if window.mouse_objects.include?(self)
      (0..2*Math::PI).step(0.01).map do |i|
        [Math.sin(i) * RANGE + xm, Math.cos(i) * RANGE + ym]
      end.each_cons(2) do |(x1,y1),(x2,y2)|
        window.draw_line(x1, y1, Gosu::Color::GRAY, x2, y2, Gosu::Color::GRAY)
      end
    end
  end

  def update(window)
    @cooldown -= 1  unless @cooldown == 0

    target = window.creeps.select do |creep|
      Math.sqrt((creep.x - xm)**2 + (creep.y - ym)**2) < RANGE
    end.sample

    if target && @cooldown == 0
      @cooldown = FIRE_RATE
      window.projectiles << Projectile.new(xm, ym, target)
    end
  end
end
