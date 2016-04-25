#!/home/pavel_busko/.rvm/rubies/ruby-2.3.0/bin/ruby
puts '********** Benchmark **********'
def benchmark(p)
  time_start = Time.now
  p.call
  time_end = Time.now
  bench_res = -(time_start - time_end).round(6)
  print 'Elapsed time ', bench_res, " seconds\n"
end
puts "\nStarting benchmark"
p = proc {sleep 1}
benchmark(p)
puts "\n********** mega_sum Method **********"
def mega_sum(array, a=0)
  sum = 0
  array.map! {|v| yield(v)} if block_given?
  array.each do |e|
    sum += e
  end
  puts sum + a
end
array = [1, 2, 3, 4]
print "\nSource array #{array}\n"
print 'Resulted sum: '
mega_sum(array, 10) { |i| i ** 2}
puts "\n********** 1..10000 range **********"
(1..1_000).each do |n|
  if n > 99 && n % 7 == 3
    puts "\nThe first number is #{n}"
    break
  end
end
puts "\n********** Keyword args **********"
def kw(*args, foo:, bar:)
  if block_given?
    if args.size > 0
      args.each {|n| yield(n)}
    else
      puts "\nERROR"
    end
  else
    puts "\nERROR"
  end
end
kw(1,2,3,4,5,foo:123, bar:123) {|i| puts i}
puts "\n********** Adding array method **********"
class Array
  def check
    tmp = []
    self.each do |n|
      if block_given? && n.even? && yield(n)
        tmp << n
      end
    end
    if tmp.size > 0
      tmp
    else
      nil
    end
  end
end
puts [2, 4, 6, 8, 10, 12, 7].check {|i| i.between?(6, 12)}.inspect
