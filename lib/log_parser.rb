# frozen_string_literal: true

class Log_Parser
  LOGREGEX = /(.*?\s)(\b.*)/.freeze

  attr_reader :log_location, :args, :paths, :stats

  def initialize(log_location, args)
    @log_location = log_location
    @args = args
    @paths = Hash.new { |h,k| h[k] = { total: 0, unique: {} } }
    @stats = {
      total: 0,
      unique: {}
    }
  end

  def execute
    File.readlines(@log_location).each do |line|
      path, ip = line.scan(LOGREGEX).first
      add_path_to(@paths[path], ip)
    end
  end

  def log_file_exists?
    File.file?(@log_location)
  end

  def to_s
    if @args.key?('m')
      @paths.sort { |(_, ad), (_, bd)| sort(ad[:total], bd[:total]) }
            .map { |p, d| "#{p} #{d[:total]} visit(s)" }.join("\n")
    elsif @args.key?('u')
      @paths.sort { |(_, ad), (_, bd)| sort(ad[:unique].length, bd[:unique].length) }
            .map { |p, d| "#{p} #{d[:unique].length} unique view(s)" }.join("\n")
    else
      "Total: #{@stats[:total]}, Unique: #{@stats[:unique].length}"
    end
  end

  private

  def add_path_to(location, ip, skip_stats = false)
    location[:total] += 1
    location[:unique][ip] = true
    add_path_to(@stats, ip, true) unless skip_stats
  end

  def sort(a, b)
    @args.key?('i') ? a <=> b : b <=> a
  end
end
