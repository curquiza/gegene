require 'yaml'
require 'open-uri'
require_relative 'gegene'
require_relative 'config_variables'

# Global
$general_config = YAML.load_file('./examples/config/ruby-config.yml')

# GET CODE SAMPLES IN TESTS FILES
code_samples = {}
Dir.glob($general_config[TESTS_FILES]) do |file|
  gegene = Gegene.new(file)
  new_code_samples = gegene.get_code_samples_in_test_file
  code_samples.merge!(new_code_samples)
end

# DISPLAY FINAL CODE-SAMPLES FILE
warnings = []
puts '# This file is generated.'
puts '# For any changes, refer to the CONTRIBUTING.md guidelines.'
puts '---'
template_file = open($general_config[TEMPLATE_URL])
template_file.each do |line|
  puts line
  unless line.start_with?('#', '---')
    template_id = line.split(':').first
    code_sample = code_samples[template_id]
    if code_sample.nil?
      warnings << template_id
    else
      puts code_sample
    end
  end
end
template_file.close

# DISPLAY MISSING CODE SAMPLES AS WARNING
# unless warnings.empty?
#   STDERR.puts 'WARNING: code samples not found for these keys:'
#   warnings.each do |key|
#     STDERR.puts "  - #{key}" unless key.start_with?('#', '---')
#   end
# end
