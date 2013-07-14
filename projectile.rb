class Projectile
  SIZE = 8
  SPEED = 3
  DAMAGE = 1

  def initialize(x, y, target, color)
    @x = x
    @y = y
    @target = target
    @color = color
  end

  def update(window)
    if !window.creeps.include?(@target)
      if window.creeps.empty?
        @dead = true
        return
      else
        @target = window.creeps.min do |creep|
          (creep.x - @x).abs + (creep.y - @y).abs
        end
      end
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
    @color
  end

  def draw(window)
    rect.draw(window, color)
  end

  def dead?
    @dead
  end
end
