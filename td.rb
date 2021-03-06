require 'gosu'
require 'hasu'

Hasu.load "rect.rb"
Hasu.load "path.rb"
Hasu.load "creep.rb"
Hasu.load "projectile_tower.rb"
Hasu.load "boom_tower.rb"
Hasu.load "buy_box.rb"

class TD < Gosu::Window
  prepend Hasu

  WIDTH = 640
  HEIGHT = 480

  attr_reader :paths, :creeps, :towers, :projectiles

  def initialize
    super(WIDTH, HEIGHT, false)
  end

  def needs_cursor?
    true
  end

  def objects
    paths + creeps + towers + projectiles
  end

  def reset
    @font = Gosu::Font.new(self, Gosu::default_font_name, 30)

    @paths = Path.build(16, 14, "uuuuuuuuuuulllllllllddddrrrrrddddllllllllluuuuuuuuuuu")

    @creeps = []
    @creep_queue = [:a] * 10 + [:b] * 20 + [:c] * 30 + [:d]
    @creep_timer = 0

    @towers = []
    @projectiles = []
    @lives = 10

    @state = :playing

    @buy_box = BuyBox.new(96, 416)
  end

  def draw
    case state
    when :playing
      Rect.new(x1:0, y1:0, x2:WIDTH, y2:HEIGHT).draw(self, Gosu::Color::BLACK)
      @paths.each{|p| p.draw(self) }
      @creeps.each{|c| c.draw(self) }
      @towers.each{|t| t.draw(self) }
      @projectiles.each{|p| p.draw(self) }

      if @buy_box.placing
        x = (mouse_x/Tower::SIZE).floor
        y = (mouse_y/Tower::SIZE).floor

        invalid = @towers.any?{|t| t.x == x && t.y == y } || @paths.any?{|t| t.x == x && t.y == y }

        tower = @buy_box.placing.new(x, y, invalid: invalid, preview: true)
        tower.draw(self)
      end

      @font.draw(@lives.to_s, 10, 10, 0, 1, 1, Gosu::Color::WHITE)
      @font.draw(@buy_box.money.to_s, 10, 440, 0, 1, 1, Gosu::Color::WHITE)

      @buy_box.draw(self)
    when :lost
      @font.draw("loser", 100, 100, 0)
    when :won
      @font.draw("winner", 100, 100, 0)
    end
  end

  def state
    if @lives <= 0
      :lost
    elsif @creeps.empty? && @creep_queue.empty?
      :won
    else
      :playing
    end
  end

  def update
    case state
    when :playing
      @towers.each{|t| t.update(self) }
      @projectiles.each{|p| p.update(self) }
      @projectiles.delete_if(&:dead?)

      @creeps.each{|c| c.update(self) }

      @creep_timer -= 1
      if @creep_timer <= 0 && !@creep_queue.empty?
        @creep_timer = 30
        @creeps << Creep.new(@creep_queue.shift, @paths.first)
      end

      end_creeps, @creeps = @creeps.partition(&:at_end?)
      @lives -= end_creeps.size
      dead_creeps, @creeps = @creeps.partition(&:dead?)
      dead_creeps.each{|c| @buy_box.money += c.value }
    when :lost
    when :won
    end
  end

  def button_down(id)
    case id
    when Gosu::MsLeft
      if @buy_box.placing && @buy_box.placing.cost <= @buy_box.money
        x = (mouse_x/Tower::SIZE).floor
        y = (mouse_y/Tower::SIZE).floor
        unless @towers.any?{|t| t.x == x && t.y == y } || @paths.any?{|t| t.x == x && t.y == y }
          @towers << @buy_box.placing.new(x, y)
          @buy_box.money -= @buy_box.placing.cost
          @buy_box.placing = nil
        end
      else
        if @buy_box.rect.contains?(mouse_x, mouse_y)
          @buy_box.click(mouse_x, mouse_y)
        end
        @towers.select do |tower|
          tower.rect.contains?(mouse_x, mouse_y)
        end.select do |tower|
          @buy_box.money >= tower.upgrade_cost
        end.select do |tower|
          tower.upgradeable?
        end.each do |tower|
          @buy_box.money -= tower.upgrade_cost
          tower.upgrade!
        end
      end
    when Gosu::MsRight
      @buy_box.placing = nil
    when Gosu::Kb1
      @buy_box.placing = BuyBox::THINGS[0]
    when Gosu::Kb2
      @buy_box.placing = BuyBox::THINGS[1]
    end
  end
end

Hasu.run(TD)
