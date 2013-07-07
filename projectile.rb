class Projectile
  SIZE = 8
  SPEED = 3
  DAMAGE = 1

  def initialize(x, y, target)
    @x = x
    @y = y
    @target = target
  end

  def update(window)
    if !window.creeps.include?(@target)
      @dead = true
      return
    end


    dx = @target.x - @x
    dy = @target.y - @y

    if dx > 0
      @x += [SPEED, dx].min
    end
    if dx < 0
      @x -= [SPEED, dx.abs].min
    end
    if dy > 0
      @y += [SPEED, dy].min
    end
    if dy < 0
      @y -= [SPEED, dy.abs].min
    end

    if @x == @target.x && @y == @target.y
      @target.hit!(DAMAGE)
      @dead = true
    end
  end

  def rect
    Rect.new(
             x1: @x - SIZE/2,
             x2: @x + SIZE/2,
             y1: @y - SIZE/2,
             y2: @y + SIZE/2,
             )
  end

  def color
    Gosu::Color::BLUE
  end

  def draw(window)
    rect.draw(window, color)
  end

  def dead?
    @dead
  end
end
