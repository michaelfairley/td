Hasu.load "tower_graphics.rb"

class BuyBox
  THINGS = [
    Tower,
  ]

  PADDING = 16

  def width
    THINGS.map{|t| t::SIZE + PADDING}.reduce(&:+) + PADDING
  end

  def height
    PADDING * 2 + THINGS.first::SIZE
  end

  attr_accessor :placing, :money

  def initialize(x, y)
    @x1 = x
    @y1 = y
    @placing = nil
    @money = 3
  end

  def rect
    Rect.new(
             x1: @x1,
             x2: @x1 + width,
             y1: @y1,
             y2: @y1 + height,
             )
  end

  def color
    Gosu::Color::GRAY
  end

  def click(x, y)
    clicked = graphics.find{|g| g.rect.contains?(x, y) }
    if clicked && @placing.nil?
      @placing = clicked.class::OWNER
    end
  end

  def graphics
    THINGS.each_with_index.map do |thing, i|
      thing::GRAPHICS.new(@x1 + i*(thing::SIZE + PADDING) + PADDING, @y1 + PADDING)
    end
  end

  def draw(window)
    rect.draw(window, color)
    graphics.each{|g| g.draw(window) }
  end
end