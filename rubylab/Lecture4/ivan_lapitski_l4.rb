#!/usr/bin/env ruby
class Command
  ALL_COMMANDS = []

  def self.check_name_of_command_in_array
    begin
      puts 'Enter your command > '
      cathed_command = $stdin.gets.chomp.downcase.split
    rescue NoMethodError
      puts 'EOF, Good Bye...'
      sleep(1)
      abort
    end

    com = ALL_COMMANDS.detect { |c| c.name == cathed_command[0] }
    print "#{com} called \nAnswer: \n"
    @@arg = cathed_command[1]

    begin
    if cathed_command.empty?
      check_name_of_command_in_array
    elsif @@arg == 'help' && com
      puts com.description
      check_name_of_command_in_array
    else
      # com
      com.run
      check_name_of_command_in_array
    end
    rescue NoMethodError
      puts 'UNKNOWN COMMAND'
      puts 'Available commands:'
      ALL_COMMANDS.map { |cmd| puts ' | ' + cmd.name + ' | <- ' + cmd.description }
      check_name_of_command_in_array
    end


  end

  protected
  def self.say(*args)
    p Time.now
    p $0
    if args
      puts args
    end
  end
end

class HelpCommand < Command

  def self.name
    'help'
  end

  def self.description
    'description of help'
  end

  def self.run
    Command::ALL_COMMANDS.each do |cmd|
      puts "#{cmd.name} #{cmd.description}"
    end
  end
end

class UpTimeCommand < Command

  def self.name
    'uptime'
  end

  def self.description
    'description of uptime command'
  end

  def self.run
    time = IO.read('/proc/uptime').split[0].to_i
    hours = (IO.read('/proc/uptime').split[0].to_i) / 3600
    minutes = (time - hours * 3600) / 60
    seconds = time - hours * 3600 - minutes * 60
    puts hours.to_s + 'h ' + minutes.to_s + 'min ' + seconds.to_s + 'sec'
  end
end

class DateCommand < Command

  def self.name
    'date'
  end

  def self.description
    'description of date command'
  end

  def self.run
    puts Time.now
  end
end

class EchoCommand < Command

  def self.name
    'echo'
  end

  def self.description
    'description of echo command'
  end

  def self.run(*words)
    if @@arg
      puts @@arg
    else
      puts 'Print your message:'
      print '---> '
      words = gets.chomp.split
      puts words[0]
    end

  end
end

class PingCommand < Command

  def self.name
    'ping'
  end

  def self.description
    'description of ping command'
  end

  def self.run(*servername, ping_count: 4)
    if @@arg
      puts "wait please...\n"
      puts `ping -q -c #{ ping_count } #{ @@arg }`
      if $?.exitstatus == 0
        puts "\n#{ @@arg } is up!\n\n"
      end
    else
      puts 'Please enter host name to ping'
      servername = gets.chomp.split
      puts "wait please...\n"
      puts `ping -q -c #{ ping_count } #{ servername[0]}`
      if $?.exitstatus == 0
        puts "\n#{servername[0]} is up!\n\n"
      end
    end
  end
end

puts 'Welcome to Console'
Command::ALL_COMMANDS.push(HelpCommand, UpTimeCommand, DateCommand, EchoCommand, PingCommand)
Command.check_name_of_command_in_array
puts 'Good Bye...'
sleep(1)
