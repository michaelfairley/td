class Creep
  SIZE = 16
  SPEED = 2

  attr_reader :x, :y

  def initialize(first_path)
    @x = first_path.xm
    @y = first_path.ym
    @next_path = first_path
    @health = 4
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
    Gosu::Color::RED
  end

  def draw(window)
    rect.draw(window, color)
  end

  def update(window)
    if @x == @next_path.xm && @y == @next_path.ym
      @next_path = window.paths[window.paths.find_index(@next_path)+1]
      return  if @next_path.nil?
    end

    dx = @next_path.xm - @x
    dy = @next_path.ym - @y

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
  end

  def at_end?
    @next_path.nil?
  end

  def hit!(damage)
    @health -= damage
  end

  def dead?
    @health <= 0
  end
end
