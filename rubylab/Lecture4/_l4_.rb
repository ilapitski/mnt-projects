#!/usr/bin/env ruby
############################
class Command
  ALL_COMMANDS = []
  ERRORS_LOG = []
  def check_name_of_command
    begin
      print '> '
      command_name = gets.chomp.downcase.split
    rescue NoMethodError
      puts 'EOF, Good Bye...'
      sleep(1)
      abort
    end
    com = ALL_COMMANDS.find { |c| c.name == command_name[0] }
    @@arg = command_name[1]
    begin
      if command_name.empty?
        check_name_of_command
      elsif @@arg == 'help' && com
        puts com.description
        check_name_of_command
      else
        com
        com.run
        check_name_of_command
      end
    rescue NoMethodError => e
      Command::ERRORS_LOG.push(e.message)
      puts 'UNKNOWN COMMAND'
      puts 'Available commands:'
      ALL_COMMANDS.map { |c| puts ' < ' + c.name + ' > - ' + c.description }
      check_name_of_command
    end
  end
 
protected
 
  def self.say(*options)
    p Time.now
    p $PROGRAM_NAME
    puts options if options
  end
end
############################
class CommandHelp < Command
  def self.name
    'help'
  end
 
  def self.run
    ALL_COMMANDS.map { |c| puts ' < ' + c.name + ' >' }
    say('ZZZZZZZZZ')
  end
 
  def self.description
    'Description of help'
  end
end
############################
class CommandDate < Command
  def self.name
    'date'
  end
 
  def self.run
    puts Time.now
  end
 
  def self.description
    'Description of date'
  end
end
##############################
class CommandUptime < Command
  def self.name
    'uptime'
  end
 
  def self.run
    begin
      time = IO.read('/proc/uptime').split[0].to_i
      hours = (IO.read('/proc/uptime').split[0].to_i) / 3600
      mins = (time - hours * 3600) / 60
      seconds = time - hours * 3600 - mins * 60
      puts hours.to_s + 'h ' + mins.to_s + 'min ' + seconds.to_s + 'sec'
    rescue Errno::ENOENT
      puts '### No uptime information found ###'
    end
  end
 
  def self.description
    'Description of uptime'
  end
end
############################
class CommandEcho < Command
  def self.name
    'echo'
  end
 
  def self.run(*word)
    if @@arg
      puts @@arg
    else
      puts 'Print your message:'
      print '---> '
      word = gets.chomp.split
      puts word[0]
    end
  end
 
  def self.description
    'Description of echo'
  end
end
############################
begin
  puts 'Welcome to Console'
  Command::ALL_COMMANDS.push(CommandHelp, CommandDate, CommandUptime, CommandEcho)
  Command.new.check_name_of_command
rescue SignalException
  puts 'Good Bye...'
  sleep(1)
end


