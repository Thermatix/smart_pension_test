# frozen_string_literal: true

class Log_Parser
  attr_reader :log_location, :args
  def initialize(log_location, args)
    @log_location = log_location
    @args = args
  end

  def log_file_exists?
    File.file?(@log_location)
  end
end
