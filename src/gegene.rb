# frozen_string_literal: true

require_relative 'current_config'

class Gegene
  def initialize(filename)
    @filename = filename
    @current_config = nil
    @comment_prefix = comment_prefix_value
  end

  def fetch_code_samples_in_test_file
    code_samples = {}
    File.foreach(@filename) do |line|
      if gegene_is_active?
        line = apply_gegene_config_to_line(line)
        current_id = @current_config.code_sample_id
        code_samples[current_id] = add_line(code_samples[current_id], line, @current_config.indent)
        @current_config.nb_lines -= 1
        @current_config = nil if @current_config.nb_lines.zero?
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

  def apply_gegene_config_to_line(line)
    line = apply_final_variable_removal(line) if should_remove_final_variable?(line)
    line = apply_replacers(line) if should_apply_replacers?
    line = remove_comment_chars(line) if line.strip.start_with? comment_chars
    line
  end

  def add_line(previous_line, new_line, indent_base)
    if previous_line.nil?
      "  #{new_line.strip}"
    else
      indented_new_line = new_line.delete_prefix(indent_base).gsub(/\n/, '')
      "#{previous_line}\n  #{indented_new_line}"
    end
  end

  def should_remove_final_variable?(line)
    @current_config.display_final_variable == false && @current_config.nb_lines == 1 && line.include?(' = ')
  end

  def apply_final_variable_removal(line)
    # WARNING: currently not work for the Go (` := `)
    line.chars.last(line.length - line.index(' = ') - 3).join
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
    line
  end

  def remove_comment_chars(line)
    if line.strip.start_with? "#{comment_chars} "
      line.sub("#{comment_chars} ", '')
    else
      line.sub(comment_chars, '')
    end
  end
end
