require 'gosu'
require 'hasu'

Hasu.load "rect.rb"
Hasu.load "path.rb"
Hasu.load "creep.rb"
Hasu.load "tower.rb"
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
    @creep_queue = [:creep] * 20
    @creep_timer = 0

    @towers = []
    @projectiles = []
    @lives = 10

    @state = :playing

    @buy_box = BuyBox.new(100, 400)
  end

  def draw
    case state
    when :playing
      Rect.new(x1:0, y1:0, x2:WIDTH, y2:HEIGHT).draw(self, Gosu::Color::GREEN)
      @paths.each{|p| p.draw(self) }
      @creeps.each{|c| c.draw(self) }
      @towers.each{|t| t.draw(self) }
      @projectiles.each{|p| p.draw(self) }

      if @buy_box.placing
        x = (mouse_x/Tower::SIZE).floor
        y = (mouse_y/Tower::SIZE).floor

        invalid = @towers.any?{|t| t.x == x && t.y == y } || @paths.any?{|t| t.x == x && t.y == y }

        graphics = TowerGraphics.new(x * Tower::SIZE, y * Tower::SIZE, invalid: invalid)
        graphics.draw(self)
        graphics.draw_ring(self)
      end

      @font.draw(@lives.to_s, 10, 10, 0, 1, 1, Gosu::Color::BLACK)
      @font.draw(@buy_box.money.to_s, 10, 440, 0, 1, 1, Gosu::Color::BLACK)

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
        @creeps << Creep.new(@paths.first)
        @creep_queue.pop
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
          @towers << Tower.new(x, y)
          @buy_box.money -= Tower.cost
          @buy_box.placing = nil
        end
      else
        if @buy_box.rect.contains?(mouse_x, mouse_y)
          @buy_box.click(mouse_x, mouse_y)
        end
      end
    when Gosu::MsRight
      @buy_box.placing = nil
    when Gosu::Kb1
      @buy_box.placing = BuyBox::THINGS.first
    end
  end
end

Hasu.run(TD)
