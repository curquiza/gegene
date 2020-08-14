#!/bin/bash

temp_file='temp_file.yml'
ruby_config_file='./examples/config/ruby-config.yml'
ruby_expected_output='./tests/expected-output-ruby.yml'

bundle exec ruby src/main.rb "$ruby_config_file" > $temp_file 2> /dev/null
diff "$ruby_expected_output" "$temp_file" &> /dev/null
if [[ "$?" -eq 0 ]]; then
    echo "OK"
    rm -f "$temp_file"
    exit 0
else
    echo "FAIL!"
    echo 'Diff found:'
    diff "$ruby_expected_output" "$temp_file"
    rm -f "$temp_file"
    exit 1
fi
