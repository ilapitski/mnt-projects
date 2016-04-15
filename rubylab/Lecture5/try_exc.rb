#!/usr/bin/env ruby
# def checker
#   # $stderr = File.open('err.log','a')
#   a = 'Asdf'
#   a +=10
# rescue TypeError => exc
#   # p exc.message.class
#   File.open('err.log', 'a') {|f| f.write("#{exc.message} \n")}
#   # $stderr.puts exc.message
#   # $stderr.close
#   puts a
# end

# def my_error (debug: false)
#   debug ? ZeroDivisionError : StandardError
# end
#
# begin
#   1/0
# rescue my_error(debug: true)
#   puts 'gsrgdg'
# end

require 'yaml'

config_yaml = YAML.load_file('config.yaml')
DEBUG = config_yaml[:debug]
p DEBUG
p config_yaml

# hash0  = { :Red => 50, :Green => 100, :Blue => 30, :Yellow => 60 }
# hash0.to_yaml
# File.open('config.yaml', 'a') do |f|
#     f.write (hash0.to_yaml)
# end

# checker