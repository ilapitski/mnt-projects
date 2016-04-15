#!/usr/bin/env ruby

a = (1..10).to_a
puts a
# a.each {|e| puts if e > 6; end}
puts a.select { |e|  e.even? }
puts a.select { |e|  e > 5 }

# Fibonacci sequence
def fibonacci(n)
  i1 = 1
  i2 = 1
  n.times do
    i1, i2 = i2, i1+i2
  end
  i1
end

ARGV[0].to_i.times do |n|
  print fibonacci(n), ' '
end
puts "\n"

