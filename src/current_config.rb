class CurrentConfig

  attr_accessor :code_sample_id
  attr_accessor :indent_spaces
  attr_accessor :display_final_variable
  attr_accessor :lines
  attr_accessor :replacers

  def initialize
    @code_sample_id = nil
    @indent_spaces = nil
    @display_final_variable = display_final_variable_default_value
    @replacers = []
    @lines = lines_default_value
  end

  def save_individual_config_line(config_line, gegene_comment_prefix)
    @code_sample_id = config_line.strip.split('=>').first.delete_prefix(gegene_comment_prefix).strip
  end

  private

  def display_final_variable_default_value
    return false if $general_config[DISPLAY_FINAL_VARIABLE] == false
    true
  end

  def lines_default_value
    $general_config[DISPLAY_FINAL_VARIABLE] || 1
  end
end
