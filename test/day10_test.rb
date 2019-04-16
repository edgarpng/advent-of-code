require "test_helper"
require_relative "../src/day10"

class Day10Test < Minitest::Test
  include Day10

  def test_draw_empty_sky
    sky = Sky.new(width: 1, height: 1)

    assert_equal ".", sky.draw
  end
  
  def test_draw_starry_sky
    sky = Sky.new(width: 1, height: 1)
    sky << Star.new(position: [0,0])
    
    assert_equal "#", sky.draw
  end

  def test_all_stars_visible
    sky = Sky.new(width: 1, height: 1)
    sky << Star.new(position: [0,0])

    assert sky.all_stars_visible?
  end

  def test_not_all_stars_visible
    sky = Sky.new(width: 10, height: 10)
    sky << Star.new(position: [0,0])
    sky << Star.new(position: [99,99])

    refute sky.all_stars_visible?
  end
  
  def test_sky_can_draw_moving_stars
    sky = Sky.new(width: 4, height: 4)
    sky << Star.new(position: [0,0], speed: [1,1]) 
    sky << Star.new(position: [3,0], speed: [-1,1]) 
    sky << Star.new(position: [0,3], speed: [1,-1]) 
    sky << Star.new(position: [3,3], speed: [-1,-1]) 
    sky.elapse
    
    drawing_after = "
      ....
      .##.
      .##.
      ....
    "

    assert_equal_ignoring_whitespace drawing_after, sky.draw
  end

  def test_with_provided_input
     input_lines = File.open('test/resources/day10.txt').readlines
     stars = parse_stars(input_lines)
     sky = large_sky(stars)

     analyzer = SkyAnalyzer.new(sky)
     max_seconds_to_analyze = 20_000
     time_until_alignment = analyzer.find_time_when_stars_align(max_seconds_to_analyze)
    
     sky = large_sky(stars)
     time_until_alignment.times {sky.elapse}

     puts "Stars aligned!\n" << sky.draw
  end

  private
  def assert_equal_ignoring_whitespace(a,b)
    spaces = /\s+/
    a = a.gsub(spaces, " ").strip
    b = b.gsub(spaces, " ").strip
    assert_equal a, b
  end

  def parse_stars(lines)
    lines.map {|line| parse_star line}
  end

  def parse_star(text)
    format = /position=<(.+),(.+)> velocity=<(.+),(.+)>/
    tokens = text.match(format).captures
    position, speed = tokens.map(&:strip).map(&:to_i).each_slice(2).to_a
    Star.new(position: position, speed: speed)
  end

  def large_sky(stars)
     sky = Sky.new(width: 300, height: 300) 
     stars.each {|star| sky << star}
     sky
  end
end
