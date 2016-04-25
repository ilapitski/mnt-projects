#!/home/pavel_busko/.rvm/rubies/ruby-2.3.0/bin/ruby
puts '******** Fibonacci ********'
def fibonacci(n)
  a = 0
  b = 1
  n.times do
    temp = a
    a = b
    b = temp + b
  end
  a
end
ARGV[0].to_i.times do |n|
  result = fibonacci(n)
  print "#{result} "
end
puts "\n******** Reverse and capitalize ********"
str1 = 'dniMyMdegnahCybuR'
puts "Source string - #{str1}"
str1.reverse!.capitalize!
puts "\n#{str1}"
puts "\n******** The same with number ********"
num = 1234567
puts "Source number - #{num}"
puts "\n#{num.to_s.reverse.to_i}"
puts "\n******** Sum of digits ********"
num_dig = 123456
puts "Source number - #{num_dig}"
puts num_dig.to_s.chars.map(&:to_i).reduce(:+)
puts "\n******** Count characters in string ********"
str2 = 'AsdpqweslkaweiaA'
puts "Source string - #{str2}"
puts str2.downcase.count('a')
puts "\n******** Check if palindrome ********"
str3 = 'qwertytrewq'
puts "Source string - #{str3}"
if str3.reverse == str3
  puts 'Yes, the string is palindrome'
else
  puts 'No, the string is not a palindrome'
end
puts "\n******** Sequence from 10 to 3 ********"
range = 10..3
(range.first).downto(range.last).each do |e|
  if e % 3 == 0
    print "#{e ** 2} "
  elsif e == 5
    next
  else
    print "#{e} "
  end
end
puts "\n******** Hash ********"
shop = {
    milk: 10,
    bread: 8,
    cornflakes: 12,
    ice_cream: 15,
    pie: 20
}
shop.each do |k, v|
  if v == 15
    puts "There is #{k} costs 15"
  end
end
puts "\n******** Add 100 to max ********"
ar = [1, 6,1,8,2,-1,3,5]
max_ar = ar.max
ar.map! do |item|
  if item == max_ar
    item += 100
  else
    item
  end
end
print ar
puts "\n******** Descending and uniq ********"
ar2 = [7, 3, [4, 5, 1], 1, 9, [2, 8, 1]]
print ar2.flatten.uniq.sort.reverse
puts ''
