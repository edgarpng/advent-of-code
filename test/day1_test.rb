require "test_helper"
require_relative "../src/day1"

class Day1Test < Minitest::Test
  def test_it_sums_every_change_in_frequency
    assert_equal 10, Day1::calculate_new_frequency(initial_frequency: 7, changes: [1, -2, 3, -4, 5])
  end

  def test_it_works_with_provided_input
    changes = File.open('test/resources/day1.txt').readlines.map(&:to_i)
    assert_equal 420, Day1::calculate_new_frequency(initial_frequency: 0, changes: changes)
  end
end
