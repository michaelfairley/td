Hasu.load "tower.rb"

class ProjectileTower < Tower
  RANGE = 128-16

  def upgrade_cost
    2
  end

  def self.cost
    5
  end

  def range
    112
  end

  def upgradeable?
    @level < 3
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
      (creep.x - xm).abs < RANGE && (creep.y - ym).abs < RANGE
    end

    if target && @cooldown == 0
      @cooldown = fire_rate
      window.projectiles << Projectile.new(xm, ym, target, color)
    end
  end

  def color
    if @invalid
      Gosu::Color.argb(0xaaff0000)
    elsif @preview
      Gosu::Color.argb(0xaa0000ff)
    else
      case @level
      when 1; Gosu::Color::BLUE
      when 2; Gosu::Color::CYAN
      when 3; Gosu::Color.argb(0xffa0a0ff)
      else; raise
      end
    end
  end
end
