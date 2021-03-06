# frozen_string_literal: true

class CurrentConfig
  attr_accessor :code_sample_id
  attr_accessor :indent
  attr_accessor :display_final_variable
  attr_accessor :nb_lines
  attr_accessor :replacers

  def initialize(config_line, gegene_comment_prefix)
    @code_sample_id = get_code_sample_id(config_line, gegene_comment_prefix)
    @indent = get_indent(config_line, gegene_comment_prefix)
    @display_final_variable = display_final_variable_default_value
    @nb_lines = nb_lines_default_value
    @replacers = replacers_default_value
    get_individual_config(config_line)
  end

  private

  def get_code_sample_id(config_line, gegene_comment_prefix)
    config_line.strip.split('=>').first.delete_prefix(gegene_comment_prefix).strip
  end

  def get_indent(config_line, gegene_comment_prefix)
    config_line.slice(0...(config_line.index(gegene_comment_prefix)))
  end

  def display_final_variable_default_value
    return true if $global_config[DISPLAY_FINAL_VARIABLE] == true

    false
  end

  def replacers_default_value
    global_replacers = $global_config[GLOBAL_REPLACERS]
    global_replacers&.map do |replacer|
      "#{replacer['search']} #{replacer['replace']}"
    end || []
  end

  def nb_lines_default_value
    $global_config[NB_LINES] || 1
  end

  def get_individual_config(config_line)
    optional_config = config_line.strip.split('=>')[1]
    optional_config&.split(OPTIONS_SEPARATOR)&.each do |option_string|
      option = option_string.split(':').map(&:strip)
      dispatch_option_into_config(option)
    end
  end

  def dispatch_option_into_config(option)
    key = option.first
    indiv_value = option[1]
    case key
    when DISPLAY_FINAL_VARIABLE
      @display_final_variable = indiv_value
    when NB_LINES
      @nb_lines = indiv_value.to_i
    when REPLACER
      @replacers.unshift(indiv_value)
    end
  end
end
