# frozen_string_literal: true

class Duration
  attr_reader :hours, :minutes, :seconds

  def initialize(hours: 0, minutes: 0, seconds: 0)
    @hours = hours
    @minutes = minutes
    @seconds = seconds
  end

  def to_seconds
    seconds + minutes * 60 + hours * 3600
  end

  def self.from_itunes(itunes_duration)
    DurationFactory.new(itunes_duration).build
  end
end

class DurationFactory
  attr_reader :itunes_duration

  def initialize(itunes_duration)
    @itunes_duration = itunes_duration
  end

  def build
    if HMS_format?
      from_HMS
    elsif MS_format?
      from_MS
    else
      from_S
    end
  end

  def from_HMS
    hours, minutes, seconds = parts
    Duration.new(hours:, minutes:, seconds:)
  end

  def from_MS
    minutes, seconds = parts
    Duration.new(minutes:, seconds:)
  end

  def from_S
    seconds = parts.first
    Duration.new(seconds:)
  end

  def parts
    itunes_duration.to_s.split(":").map(&:to_i).compact.first(3)
  end

  def MS_format?
    parts.size == 2
  end

  def HMS_format?
    parts.size == 3
  end
end
