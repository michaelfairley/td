class Creep
  SIZE = 16
  SPEED = 2

  attr_reader :x, :y

  TYPE_HEALTH = {
    :a => 1,
    :b => 4,
    :c => 16,
    :d => 64,
  }

  TYPE_COLOR = {
    :a => Gosu::Color.argb(0xffffd700),
    :b => Gosu::Color.argb(0xffffa500),
    :c => Gosu::Color.argb(0xffff4500),
    :d => Gosu::Color::RED
  }

  TYPE_VALUE = {
    :a => 1,
    :b => 2,
    :c => 4,
    :d => 8,
  }

  def initialize(type, first_path)
    @x = first_path.xm
    @y = first_path.ym
    @next_path = first_path

    @type = type

    @health = TYPE_HEALTH.fetch(@type)
  end

  def value
    TYPE_VALUE.fetch(@type)
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
    Gosu::Color::BLACK
  end

  def health_color
    TYPE_COLOR.fetch(@type)
  end

  def base_health_rects
    health_sqrt = Math.sqrt(TYPE_HEALTH.fetch(@type)).to_i
    small_size = SIZE / health_sqrt
    big_rect = rect

    health_sqrt.times.flat_map do |x|
      health_sqrt.times.map do |y|
        Rect.new(
                 x1: big_rect.x1 + x * small_size,
                 x2: big_rect.x1 + (x+1) * small_size,
                 y1: big_rect.y1 + y * small_size,
                 y2: big_rect.y1 + (y+1) * small_size,
                 )
      end
    end
  end

  def health_rects
    base_health_rects.first(@health)
  end

  def draw(window)
    rect.draw(window, color)
    health_rects.each{|hr| hr.draw(window, health_color) }
  end

  def update(window)
    if (@next_path.xm-@x).abs <= 1 && (@next_path.ym-@y).abs <= 1
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
