# frozen_string_literal: true

require 'yaml'
require 'open-uri'
require_relative 'gegene'
require_relative 'config_variables'

if ARGV.empty?
  warn 'Error: a config file is needed.'
  warn 'Usage:'
  warn '  $ bundle exec ruby src/main.rb <config-file-path>'
  exit 1
end

# Global
$global_config = YAML.load_file(ARGV.first)

# GET CODE SAMPLES IN TESTS FILES
code_samples = {}
Dir.glob($global_config[TESTS_FILES]) do |file|
  gegene = Gegene.new(file)
  new_code_samples = gegene.get_code_samples_in_test_file
  code_samples.merge!(new_code_samples)
end

# DISPLAY FINAL CODE-SAMPLES FILE
warnings = []
puts '# This file is generated.'
puts '# For any changes, refer to the CONTRIBUTING.md guidelines.'
puts '---'
template_file = URI.open($global_config[TEMPLATE_URL])
template_file.each do |line|
  puts line
  next if line.start_with?('#', '---')

  template_id = line.split(':').first
  code_sample = code_samples[template_id]
  if code_sample.nil?
    warnings << template_id
  else
    puts code_sample
  end
end
template_file.close

# DISPLAY MISSING CODE SAMPLES AS WARNING
unless warnings.empty?
  warn 'WARNING: code samples not found for these keys:'
  warnings.each do |key|
    warn "  - #{key}" unless key.start_with?('#', '---')
  end
end
