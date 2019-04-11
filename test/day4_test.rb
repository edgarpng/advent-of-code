require "test_helper"
require_relative "../src/day4"

class Day4Test < Minitest::Test
  def test_top_entry_has_most_frequent_minute
    log_entries = lines <<-log
      [1500-01-01 00:00] Guard #666 begins shift
      [1500-01-01 00:01] falls asleep
      [1500-01-01 00:05] wakes up
      [1500-01-02 00:04] falls asleep
      [1500-01-02 00:08] wakes up
    log
    analyzer = Day4::LogAnalyzer.new(log_entries)
    most_frequent_minute_asleep = analyzer.statistics.top_entry.last
    
    assert_equal 4, most_frequent_minute_asleep
  end

  def test_top_entry_has_correct_guard
    log_entries = lines <<-log
      [1500-01-01 00:00] Guard #111 begins shift
      [1500-01-01 00:01] falls asleep
      [1500-01-01 00:02] wakes up
      [1500-01-02 00:00] Guard #666 begins shift
      [1500-01-02 00:01] falls asleep
      [1500-01-02 00:59] wakes up
    log
    analyzer = Day4::LogAnalyzer.new(log_entries)
    guard_id = analyzer.statistics.top_entry.first
    
    assert_equal 666, guard_id 
  end
  
  def test_with_provided_input 
    log_entries = File.open('test/resources/day4.txt').readlines 
    analyzer = Day4::LogAnalyzer.new(log_entries)
    guard_id, most_frequent_minute_asleep = analyzer.statistics.top_entry
    
    assert_equal 2381, guard_id
    assert_equal 44, most_frequent_minute_asleep
  end

  def lines(text)
    text.lines.map(&:chomp)
  end
end
