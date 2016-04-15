#!/usr/bin/env ruby

puts "----------------------------Task1-----------------------------------\n"

p1 = Proc.new do
  t1 = Time.now
  ('aaaa'..'zzzz').to_a
  t2 = Time.now
  puts "Time to create array from range: #{ t2-t1 } seconds"
end

def xxx(p)
  p.call
end

xxx(p1)

puts "----------------------------Task2-----------------------------------\n"

array0 = [1, 2, 3, 4]
def mega_sum(array, *args)
  if !block_given? && args.empty?
    print array.inject(:+), "\n"

  elsif !block_given? && !args.empty?
    print array.clone.push(args).flatten.inject(:+), "\n"

  elsif block_given? && args.empty?
    print array.map { |e| yield e }.flatten.inject(:+), "\n"

  elsif block_given? && !args.empty?
    print array.map { |e| yield e }.push(args).flatten.inject(:+), "\n"
  end
end

mega_sum(array0)
mega_sum(array0, 10)
mega_sum(array0) { |i| i ** 2}
mega_sum(array0, 10) { |i| i ** 2}

puts "----------------------------Task3-----------------------------------\n"

(1..1000).to_a.each do |i|
    if i < 100
      next
    elsif i % 7 == 3
      puts "#{i} modulus 7 = 0"
      break
    end
end

puts "----------------------------Task4-----------------------------------\n"

def args_method( *args,  arg1: 'keyword_arg1', arg2: 'keyword_arg2', &block )
  block.call(args)
  puts "Hello from #{arg1} and #{arg2}"
end

args_method(11, 12, (1..2).to_a){|i| puts i }
puts "\n"
args_method{|i| puts i }

# args_method() # => undefined method `call' for nil:NilClass (NoMethodError)

puts "----------------------------Task5-----------------------------------\n"

class Array
  def method_on_array
    array0 = self.select{ |e| yield e}
    self.select {|e| e.even?}.select do |e|
      array0.empty? ? (return nil) : (yield e)
    end
  end
end

puts [1, 2, 3, 4, 5, 6, 7].method_on_array { |i| i > 2}.inspect # => [4, 6]
puts [1, 2, 3, 4, 5, 6, 7].method_on_array { |i| i > 10}.inspect # => nil
puts [2, 4, 6, 8, 10, 12, 7].method_on_array {|i| i.between?(6, 12)}
         .inspect # => [6, 8, 10, 12]