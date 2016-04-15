#!/usr/bin/env ruby

# p1 = Proc.new do |e|
#   t1 = Time.now
#   ('aaaaa'..'zzzzz').to_a
#   t2 = Time.now
#   puts "Time to convert range => array: #{ t2-t1 }"
# end
#
# def xxx(p)
#   p.call
# end
#
# xxx(p1)

# array0 = [1, 2, 3, 4]
# array1 = array0.clone
# array2 = array0.clone
# array3 = array0.clone
#
# def mega_sum(array0, *args)
#   if block_given?
#     print array0.map! { |e| yield e }.push(args).flatten.inject(:+), " block called \n"
#   elsif args.empty?
#     print array0.push(args).flatten.inject(:+), " with args \n"
#   else
#     print array0.inject(:+), " without args \n"
#   end
# end
#
# mega_sum(array0)
# mega_sum(array1, 10)
# mega_sum(array2) { |i| i ** 2}
# mega_sum(array3, 10) { |i| i ** 2}
# puts "\n"
#
# (1..1000).to_a.each do |i|
#     if i < 100
#       next
#     elsif i % 7 == 3
#       puts "#{i} modulus 7 = 0"
#       break
#     end
# end
# puts "\n"
# print 'Hello'



