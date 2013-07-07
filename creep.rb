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

  def value
    1
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
    if @next_path.rect.contains?(@x, @y)
      @next_path = window.paths[window.paths.find_index(@next_path)+1]
      return  if @next_path.nil?
    end

    dx = @next_path.xm - @x
    dy = @next_path.ym - @y

    dh = Math.sqrt(dx**2 + dy**2)

    if dh > SPEED
      scale = SPEED/dh
      dy *= scale
      dx *= scale
    end

    @x += dx
    @y += dy
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
