class Day1
  def self.calculate_new_frequency(initial_frequency:, changes:)
   changes.reduce(initial_frequency, :+)
  end
end
