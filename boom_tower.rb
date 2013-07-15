Hasu.load "tower.rb"

class BoomTower < Tower
  RANGE = 128-16

  def self.cost
    5
  end

  def upgrade_cost
    2
  end

  def range
    112
  end

  def upgradeable?
    @level < 3
  end

  def fire_rate
    case @level
    when 1; 50
    when 2; 40
    when 3; 30
    else; raise
    end
  end

  def draw(window)
    super

    if @firing
      @firing = false

      boom_rect = Rect.new(x1: xm - range, x2: xm + range, y1: ym - range, y2: ym + range)
      boom_rect.draw(window, color)
    end
  end

  def color
    if @invalid
      Gosu::Color.argb(0xaaff0000)
    elsif @preview
      Gosu::Color.argb(0xaa00ff00)
    else
      case @level
      when 1; Gosu::Color.argb(0xff00aa00)
      when 2; Gosu::Color.argb(0xff00ff00)
      when 3; Gosu::Color.argb(0xffa0ffa0)
      else; raise
      end
    end
  end

  def update(window)
    @cooldown -= 1  unless @cooldown == 0

    targets = window.creeps.select do |creep|
      (creep.x - xm).abs < RANGE && (creep.y - ym).abs < RANGE
    end

    if !targets.empty? && @cooldown == 0
      @firing = true
      @cooldown = fire_rate
      targets.each{|t| t.hit!(1) }
    end
  end
end
