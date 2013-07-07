require 'gosu'
require 'hasu'

Hasu.load "rect.rb"
Hasu.load "path.rb"
Hasu.load "creep.rb"
Hasu.load "tower.rb"

class TD < Gosu::Window
  prepend Hasu

  WIDTH = 640
  HEIGHT = 480

  attr_reader :paths, :creeps, :towers, :projectiles, :mouse_objects

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

    @towers = [Tower.new(10, 5), Tower.new(5, 5), Tower.new(14, 9)]
    @projectiles = []
    @score = 10

    @state = :playing
  end

  def draw
    case state
    when :playing
      Rect.new(x1:0, y1:0, x2:WIDTH, y2:HEIGHT).draw(self, Gosu::Color::GREEN)
      @paths.each{|p| p.draw(self) }
      @creeps.each{|c| c.draw(self) }
      @towers.each{|t| t.draw(self) }
      @projectiles.each{|p| p.draw(self) }

      @font.draw(@score.to_s, 10, 10, 0, 1, 1, Gosu::Color::BLACK)
    when :lost
      @font.draw("loser", 100, 100, 0)
    when :won
      @font.draw("winner", 100, 100, 0)
    end
  end

  def state
    if @score <= 0
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
      @creeps.delete_if(&:dead?)

      @creep_timer -= 1
      if @creep_timer <= 0 && !@creep_queue.empty?
        @creep_timer = 30
        @creeps << Creep.new(@paths.first)
        @creep_queue.pop
      end

      end_creeps, @creeps = @creeps.partition(&:at_end?)
      @score -= end_creeps.size

      @mouse_objects = objects.select do |object|
        object.rect.contains?(mouse_x, mouse_y)
      end
    when :lost
    when :won
    end
  end
end

Hasu.run(TD)
