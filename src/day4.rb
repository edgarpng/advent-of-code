require 'time'

module Day4
  class LogAnalyzer
    def initialize(log_entries)
      @events = log_entries.map {|entry| Event.from_log_entry entry}
    end

    def statistics
      stats = SleepStatistics.new
      @events.sort.reduce(stats) {|stats, event| event.process stats}
    end
  end

  class SleepStatistics
    attr_accessor :current_guard

    def initialize
      @counts = Hash.new {|hash, key| hash[key] = Hash.new(0)}
    end

    def start_sleep(timestamp)
      @time_started = timestamp
    end

    def end_sleep(timestamp)
      minutes_slept = @time_started.min ... timestamp.min
      minutes_slept.each {|minute| register_sleep minute}
    end

    def top_entry
      sorted_counts = @counts.sort_by {|_, minute_counts| minute_counts.values.sum} 
      guard_with_most_minutes, minute_count = sorted_counts.last
      most_frequent_minute = minute_count.sort_by {|_, frequency| frequency}.last.first
      return guard_with_most_minutes, most_frequent_minute
    end

    private
    def register_sleep(minute)
      current_count = @counts[current_guard]
      current_count[minute] += 1
    end
  end

  class Event
    include Comparable
    attr_reader :timestamp, :description

    def initialize(timestamp, description)
      @timestamp = timestamp
      @description = description
    end

    def process(statistics)
      case description
      when "falls asleep"
        statistics.start_sleep timestamp
      when "wakes up"
        statistics.end_sleep timestamp
      else
        statistics.current_guard = guard_id
      end
      statistics
    end

    def <=>(other)
      timestamp <=> other.timestamp  
    end

    def self.from_log_entry(log_entry)
      timestamp, description = log_entry.match(/\[(.+)\] (.+)/).captures
      timestamp = Time.parse timestamp
      Event.new(timestamp, description)
    end

    private
    def guard_id
      description.match(/(?<=#)\d+/)[0].to_i 
    end
  end
end
