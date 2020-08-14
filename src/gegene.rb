require_relative 'current_config'

class Gegene

  def initialize(filename)
    @filename = filename
    @current_config = nil
    @comment_prefix = comment_prefix_value
  end

  def get_code_samples_in_test_file
    code_samples = {}
    File.foreach(@filename) do |line|
      if gegene_is_active?
        code_samples[@current_config.code_sample_id] = line.strip
        @current_config = nil
      elsif gegene_line?(line)
        @current_config = CurrentConfig.new
        @current_config.save_individual_config_line(line, @comment_prefix)
        next
      end
    end
    code_samples
  end

  private

  def gegene_is_active?
    !@current_config.nil?
  end

  def gegene_line?(line)
    line.strip.start_with?(@comment_prefix)
  end

  def comment_prefix_value
    "#{comment_chars} GEGENE"
  end

  def comment_chars
    if @filename.end_with?('.py', '.rb')
      '#'
    else
      '//'
    end
  end

end
