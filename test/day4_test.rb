require "test_helper"
require_relative "../src/day4"

class Day4Test < Minitest::Test
  def test_guard_with_most_minutes_asleep
    log_entries = lines <<-log
      [1500-01-01 00:00] Guard #111 begins shift
      [1500-01-01 00:01] falls asleep
      [1500-01-01 00:02] wakes up
      [1500-01-02 00:00] Guard #666 begins shift
      [1500-01-02 00:01] falls asleep
      [1500-01-02 00:59] wakes up
      [1500-01-03 00:01] falls asleep
      [1500-01-02 00:02] wakes up
    log
    analyzer = Day4::LogAnalyzer.new(log_entries)
    guard_id, most_frequent_minute_asleep = analyzer.statistics.top_sleeper_by_total_time
    
    assert_equal 666, guard_id
    assert_equal 1, most_frequent_minute_asleep
  end

  def test_guard_most_frequently_asleep_on_same_minute
    log_entries = lines <<-log
      [1500-01-01 00:00] Guard #111 begins shift
      [1500-01-01 00:01] falls asleep
      [1500-01-01 00:02] wakes up
      [1500-01-02 00:01] falls asleep
      [1500-01-02 00:02] wakes up
      [1500-01-03 00:00] Guard #666 begins shift
      [1500-01-03 00:01] falls asleep
      [1500-01-03 00:59] wakes up
    log
    analyzer = Day4::LogAnalyzer.new(log_entries)
    guard_id, most_frequent_minute_asleep = analyzer.statistics.top_sleeper_on_single_minute

    assert_equal 111, guard_id
    assert_equal 1, most_frequent_minute_asleep
  end
  
  def test_with_provided_input 
    log_entries = File.open('test/resources/day4.txt').readlines 
    statistics = Day4::LogAnalyzer.new(log_entries).statistics
    guard_id, most_frequent_minute_asleep = statistics.top_sleeper_by_total_time

    assert_equal 2381, guard_id
    assert_equal 44, most_frequent_minute_asleep

    guard_id, most_frequent_minute_asleep = statistics.top_sleeper_on_single_minute

    assert_equal 3137, guard_id
    assert_equal 41, most_frequent_minute_asleep
  end

  def lines(text)
    text.lines.map(&:chomp)
  end
end
