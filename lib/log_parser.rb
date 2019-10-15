# frozen_string_literal: true

class Log_Parser
  attr_reader :log_location
  def initialize(log_location)
    @log_location = log_location
  end

  def log_file_exists?
    File.file?(@log_location)
  end
end
