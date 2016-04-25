#!/home/pavel_busko/.rvm/rubies/ruby-2.3.0/bin/ruby
require 'net/ping'
trap('SIGINT') {puts "\nBye"; exit 130}
class Command
  ALL_COMMANDS = []
  def self.say(args)
    print Time.now, ' ', $0, ' params -  ', args, "\n\n"
  end
  def self.check(*args)
    if ALL_COMMANDS.detect {|e| e.name == args[0].downcase}
      ALL_COMMANDS.each do |cmd|
        if cmd.name.to_s.downcase == args[0].downcase
          cmd.run(args[1])
        end
      end
    else
      puts 'There is no such command. Type "help" to check out available commands'
    end
  end
end


class HelpCommand < Command
  Command::ALL_COMMANDS.push(self)
  def self.name
    'help'
  end
  def self.description
    'This command prints list of commands'
  end
  def self.run(arg)
    say(arg)
    Command::ALL_COMMANDS.each do |cmd|
      puts "#{cmd.name} - #{cmd.description}"
    end
  end
end


class UptimeCommand < Command
  Command::ALL_COMMANDS.push(self)
  def self.name
    'uptime'
  end
  def self.description
    'This command returns current uptime'
  end
  def self.run(arg)
    say(arg)
    uptime = File.read('/proc/uptime').split[0].to_i
    uptime_h = Time.at(uptime).utc.strftime('%H')
    uptime_m = Time.at(uptime).utc.strftime('%M')
    uptime_s = Time.at(uptime).utc.strftime('%S')
    puts "Uptime is #{uptime_h}h #{uptime_m}m #{uptime_s}s "
  end
end


class DateCommand < Command
  Command::ALL_COMMANDS.push(self)
  def self.name
    'date'
  end
  def self.description
    'This command returns current date/time'
  end
  def self.run(arg)
    say(arg)
    puts "Current date and time - #{Time.now}"
  end
end


class EchoCommand < Command
  Command::ALL_COMMANDS.push(self)
  def self.name
    'echo'
  end
  def self.description
    'This command prints the first argument passed by command'
  end
  def self.run(arg)
    say(arg)
    puts arg
  end
end


class PingCommand < Command
  Command::ALL_COMMANDS.push(self)
  def self.name
    'ping'
  end
  def self.description
    'Check if server is accessible'
  end
  def self.run(address, count=1)
    say(address)
    puts Net::Ping::External.new(address).ping?
  end
end


puts '*******************************************'
puts '*                                         *'
puts '*              BEAUTIFUL CMD              *'
puts '*                                         *'
puts '*******************************************'
puts 'type "help" to check out available commands'
print "\n"


while TRUE
  print '=> '
  a = gets
  Command.check(*(a.chomp.split))
end