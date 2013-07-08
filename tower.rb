Hasu.load "projectile.rb"
Hasu.load "tower_graphics.rb"

class Tower
  GRAPHICS = TowerGraphics

  SIZE = 32
  RANGE = 100

  def self.cost
    3
  end

  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
    @cooldown = 0
    @level = 1
  end

  def graphics
    TowerGraphics.new(@x*SIZE, @y*SIZE, level: @level)
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
    graphics.draw(window)

    if rect.contains?(window.mouse_x, window.mouse_y)
      graphics.draw_ring(window)
    end
  end

  def upgrade_cost
    2
  end

  def upgradeable?
    @level < 3
  end

  def upgrade!
    @level += 1
  end

  def fire_rate
    case @level
    when 1; 20
    when 2; 15
    when 3; 10
    else; raise
    end
  end

  def update(window)
    @cooldown -= 1  unless @cooldown == 0

    target = window.creeps.find do |creep|
      Math.sqrt((creep.x - xm)**2 + (creep.y - ym)**2) < RANGE
    end

    if target && @cooldown == 0
      @cooldown = fire_rate
      window.projectiles << Projectile.new(xm, ym, target, graphics.color)
    end
  end
end
