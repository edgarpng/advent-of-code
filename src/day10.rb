require "matrix"

module Day10
  class Star
    attr_reader :speed, :position
    
    def initialize(position:, speed: [0,0])
      @position = Vector[position[0], position[1]]
      @speed = Vector[speed[0], speed[1]]
    end

    def move
      @position += speed
    end
  end

  class Sky
    EMPTY_SPACE_CHARACTER = "."
    STAR_CHARACTER = "#"

    attr_reader :width, :height
    attr_accessor :stars, :visible_sky
    private :visible_sky

    def initialize(width:, height:)
      @width = width
      @height = height
      @stars = []
    end

    def <<(star)
      stars << star.dup
    end

    def draw
      clear!
      stars.each {|star| draw_star star}
      visible_sky.map(&:join).join("\n")
    end
    
    def elapse
      stars.each &:move
    end

    def all_stars_visible?
      stars.all? {|star| visible? star}
    end

    private
    def clear!
      self.visible_sky = Array.new(height) {|_| Array.new(width) {|_| EMPTY_SPACE_CHARACTER}}
    end

    def draw_star(star)
      if visible? star
        x, y = star.position.to_a
        visible_sky[y][x] = STAR_CHARACTER
      end
    end

    def visible?(star)
      x_axis = 0...width
      y_axis = 0...height
      x, y = star.position.to_a

      x_axis.include?(x) && y_axis.include?(y)
    end
  end

  class SkyAnalyzer
    attr_reader :sky

    def initialize(sky)
      @sky = sky.dup
    end

    def find_time_when_stars_align(max_seconds_to_analyze)
      x_differences = {}
      max_seconds_to_analyze.times do |second|
        x_positions = sky.stars.map {|star| star.position[0]}
        x_differences[second] = x_positions.max - x_positions.min
        sky.elapse
      end

      time_of_lowest_value(x_differences)
    end

    private
    def time_of_lowest_value(differences)
      differences.min_by {|_, difference| difference}.first
    end
  end
end
