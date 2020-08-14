#!/bin/bash

ret_code=0
temp_file='temp_file.yml'
ruby_config_file='./examples/config/ruby-config.yml'
ruby_expected_output='./tests/expected-output-ruby.yml'
php_config_file='./examples/config/php-config.yml'
php_expected_output='./tests/expected-output-php.yml'

# Usage: test_with $language $config_file $output_file
test_with() {
  echo "Testing with $1..."
  bundle exec ruby src/main.rb "$2" > $temp_file 2> /dev/null
  diff "$3" "$temp_file" &> /dev/null
  if [[ "$?" -eq 0 ]]; then
      echo "OK"
  else
      echo "FAIL!"
      echo 'Diff found:'
      diff "$3" "$temp_file"
      ret_code=1
  fi
}

test_with 'ruby' "$ruby_config_file" "$ruby_expected_output"
test_with 'PHP' "$php_config_file" "$php_expected_output"
rm -f "$temp_file"
exit $ret_code
