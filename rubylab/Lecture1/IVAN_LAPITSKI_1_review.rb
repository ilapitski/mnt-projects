#!/usr/bin/env ruby
=begin
1)установить системный Ruby через yum
sudo yum install ruby

2)установить новые библиотеки-гемы pry, sqlite3 (возможно понадобится установка дополнительных dev -пакетов)
sudo yum install gcc g++ make automake autoconf curl-devel openssl-devel \
zlib-devel httpd-devel apr-devel apr-util-devel sqlite-devel

sudo yum install rubygems

sudo yum install ruby-devel

sudo gem install sqlite3 # NOTE: is superpower required here?
sudo gem install pry

3)удалить гемы
sudo gem uninstall pry
sudo gem uninstall sqlite3

sudo gem uninstall --all

4)удалить системный Ruby
sudo yum remove rubygems
sudo yum remove ruby

5)установить Ruby 2.3.0 через RVM
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash

rvm install 2.3.0

6)создать новый gemset mtn , сделать его дефолтным при заходе в баш
rvm 2.3.0
rvm gemset create mtn
rvm --default use 2.3.0@mtn

7)установить в нем библиотеки-гемы pry , sqlite3
gem install sqlite3
gem install pry
=end

def largest_key(hash1)
  hash1.max_by{|k,v| v}[0]
end

def largest_value(hash1)
  hash1.max_by{|k,v| v}[1]
end # NOTE: both methods looks almost identical, seems one would be enough,
# just use indexing on its result

hash0  = { :Red => 50, :Green => 100, :Blue => 30, :Yellow => 60 } # NOTE: small letter please

puts "Key with largest value is #{largest_key(hash0)}"
puts "Largest value is #{largest_value(hash0)}","\n"

if hash0.values_at(:Green)[0] > hash0.values_at(:Yellow)[0] # NOTE: To complex, just `hash0[:Green] > hash0[:Yellow]` would be enough
  puts 'Green more then Yellow'
else
  puts 'Yellow more then Green'
end

if hash0.values_at(:Green)[0] > hash0.values_at(:Blue, :Red).inject(:+) # NOTE: Cool!
  puts 'Green more then Blue and Red',"\n"
else
  puts 'Blue and Red more then Green',"\n"
end

def need_blr(dollars_need0, rate0, fee0)
  (dollars_need0*rate0*(1 + fee0)).to_i # NOTE: fine, but rounding here should to upper rather that smaller
end

def can_buy(rate1, i_have1, fee1)
  (i_have1/(rate1*(1+fee1))).to_i
end

def ice_cream(rate2, i_have2, fee2, ice_cream_cost2)
  ice_cream_cost2 <= (((i_have2/(rate2*(1+fee2))).modulo(1))*(rate2*(1+fee2))).to_i # NOTE: to complex, should be much easier
end

rate, dollars, fee, i_have, ice_cream_cost = 20150, 270, 0.3, 5600000, 10000

puts "Need #{need_blr(dollars, rate, fee)} BLR to buy 270 dollars"
puts "I can buy #{can_buy(rate, i_have, fee)} BLR with #{i_have} BLR"

if ice_cream(rate,i_have,fee,ice_cream_cost)
  puts 'yes, I Can buy ice cream on left money'
else
  puts 'no, I can not buy ice cream on left BLR'
end


# NOTE: Good!
# methods should contain repeatable logic, not the entire calculation, as it just has no sense.

