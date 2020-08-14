class CurrentConfig

  attr_accessor :code_sample_id
  attr_accessor :indent
  attr_accessor :display_final_variable
  attr_accessor :nb_lines
  attr_accessor :replacers

  def initialize
    @code_sample_id = nil
    @indent = nil
    @display_final_variable = display_final_variable_default_value
    @nb_lines = nb_lines_default_value
    @replacers = []
  end

  def save_individual_config_line(config_line, gegene_comment_prefix)
    @indent = config_line.slice(0...(config_line.index(gegene_comment_prefix)))
    indiv_config = config_line.strip.split('=>')
    @code_sample_id = indiv_config.first.delete_prefix(gegene_comment_prefix).strip
    if indiv_config[1]
      options = indiv_config[1].split('-').map do |option_string|
        option = option_string.split(':').map(&:strip)
        key = option.first
        indiv_value = option[1]
        case key
        when DISPLAY_FINAL_VARIABLE
          @display_final_variable = indiv_value
        when NB_LINES
          @nb_lines = indiv_value.to_i
        when REPLACER
          @replacers << indiv_value
        end
      end
    end

  end

  private

  def display_final_variable_default_value
    return false if $general_config[DISPLAY_FINAL_VARIABLE] == false
    true
  end

  def nb_lines_default_value
    $general_config[NB_LINES] || 1
  end

  def get_code_sample_id(mandatory_config, gegene_comment_prefix)
    mandatory_config
  end
end
