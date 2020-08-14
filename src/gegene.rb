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
        apply_gegene_config(line, code_samples)
        @current_config.nb_lines -= 1
        @current_config = nil if @current_config.nb_lines == 0
      elsif gegene_line?(line)
        @current_config = CurrentConfig.new(line, @comment_prefix)
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

  def apply_gegene_config(line, code_samples)
    current_id = @current_config.code_sample_id
    if should_remove_final_variable?(line)
      # WARNING: currently not work for the Go (`:=`)
      line = line.chars.last(line.length - line.index(' = ') - 3).join
    end
    if should_apply_replacers?
      line = apply_replacers(line)
    end
    code_samples[current_id] = add_line(
      code_samples[current_id],
      line,
      @current_config.indent
    )
  end

  def add_line(previous_line, new_line, indent_base)
    if previous_line.nil?
      "  #{new_line.strip}"
    else
      indented_new_line = new_line.delete_prefix(indent_base).gsub(/\n/, "")
      "#{previous_line}\n  #{indented_new_line}"
    end
  end

  def should_remove_final_variable?(line)
    @current_config.display_final_variable == false && @current_config.nb_lines == 1 && line.include?(' = ')
  end

  def should_apply_replacers?
    !@current_config.replacers.empty?
  end

  def apply_replacers(line)
    @current_config.replacers.each do |replacer|
      split_index = replacer.index(' ')
      to_search = replacer[0...split_index]
      replace_by = replacer[(split_index + 1)..]
      line = line.gsub(to_search, replace_by)
    end
    return line
  end

end
