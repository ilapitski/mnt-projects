#!/home/pavel_busko/.rvm/rubies/ruby-2.3.0/bin/ruby
=begin
Установка ruby с помощью yum:
  Устанавливаем ruby: yum install ruby ruby-devel ruby-irb
  Устанавливаем либы: yum install ruby-sqlite
  Удаляем ruby: yum remove ruby
                yum remove rubygems

Установка с помощью rvm:
  Добавляем ключ: gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  Устанавливаем rvm: \curl -sSL https://get.rvm.io | bash -s stable
  Устанавливаем ruby: rvm install 2.3.0
  Создаём gemset: rvm gemset create mtn
  Делаем mtn дефолтным при заходе в баш: rvm --default use 2.3.0@mtn
  Усталавливаем либы: gem install pry
                      gem install sqlite3
                      gem install sqlite3
=end
class Bucket
  def initialize(number, color)
    @count = number
    @color = color
  end
  def get_number
    @count
  end
  def get_color
    @color
  end
end
puts '*************First task*************'
green = Bucket.new(100, 'green')
red = Bucket.new(50, 'red')
blue = Bucket.new(30, 'blue')
yellow = Bucket.new(60, 'yellow')
array = []
ObjectSpace.each_object Bucket do |obj|
  array << obj.get_number
end
ObjectSpace.each_object Bucket do |obj|
  if obj.get_number == array.max
    puts "Наибольшее число в #{obj.get_color} ведре"
  end
end
if green.get_number > yellow.get_number ||
   green.get_number > (red.get_number + blue.get_number)
  puts 'Да, в зелёном ведре шаров больше'
else
  puts 'Нет, в зелёном ведре шаров меньше'
end
puts "\n*************Second task*************"
exchange_course = 20150 + (20150 * 0.3)
puts "\nЧто бы купить 270 долларов нужно заплатить #{(exchange_course * 270).to_i} рублей"
available_dollars = (5600000/exchange_course).to_i
rest = (available_dollars*exchange_course).to_i
if rest > 10000
  puts "На 5600000 рублей можно купить #{available_dollars} долларов и ещё на мороженное останется"
else
  puts "На 5600000 рублей можно купить #{available_dollars} долларов, но на мороженное не хватит"
end
