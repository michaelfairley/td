Hasu.load "projectile.rb"
Hasu.load "tower_graphics.rb"

class Tower
  GRAPHICS = TowerGraphics

  SIZE = 32
  RANGE = 100
  FIRE_RATE = 20

  def self.cost
    3
  end

  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
    @cooldown = 0
    @graphics = TowerGraphics.new(@x*SIZE, @y*SIZE)
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
    @graphics.draw(window)

    if rect.contains?(window.mouse_x, window.mouse_y)
      @graphics.draw_ring(window)
    end
  end

  def update(window)
    @cooldown -= 1  unless @cooldown == 0

    target = window.creeps.find do |creep|
      Math.sqrt((creep.x - xm)**2 + (creep.y - ym)**2) < RANGE
    end

    if target && @cooldown == 0
      @cooldown = FIRE_RATE
      window.projectiles << Projectile.new(xm, ym, target)
    end
  end
end
