#!/usr/bin/env ruby
require 'yaml'
class Command
  ALL_COMMANDS = []

  begin
    @config_yaml = YAML.load_file( 'ivan_lapitski_l5.yaml' )
  rescue Errno::ENOENT
    puts '->no config file found, generating default'
    File.open('ivan_lapitski_l5.yaml', 'w') do |f|
      f.write ({:output_log=> 'ivan_lapitski_l5.log',
                :error_log => 'script_errors.log',
                :debug=> true,
                :commands => {:help=>"type 'command_name --help' to see description",
                              :uptime => 'will give you OS uptime',
                              :date => "prints today's date",
                              :echo=> 'echo you args',
                              :ping=> 'to ping everything'}}.to_yaml)
    end
  retry
  end

  if ARGV[0] == '--debug'
    puts '->debug mode on'
    @debug_mode_option = true
  else
    @debug_mode_option = false
  end

  def self.my_error_method (debug)
    debug ? NoMethodError : StandardError
  end

  def self.command_by_name
    print ' > '
    begin
      caught_command = $stdin.gets.chomp.downcase.split

      if caught_command[0] == 'exit'
        File.open( @config_yaml[:output_log], 'a') {|f| f.write("#{Time
            .now.strftime('%H:%M')} - Execution stopped \n")}
        puts "\nGood Bye!"
        exit 0
      end

      caught_class = ALL_COMMANDS.detect { |c| c.name == caught_command[0] }
      @@caught_arguments = caught_command[1]
    rescue NoMethodError, Interrupt => e
      File.open( @config_yaml[:output_log], 'a') {|f| f.write("#{Time
          .now.strftime('%H:%M')} - Execution stopped \n")}
      puts "\nGood Bye!"
      exit 0
    end

    caught_command.empty? ? command_by_name :

    if caught_class.nil?
      print "-> Answer:\n > NilClass caught..\n\
 > Command unknown, available commands:\n"
      @config_yaml[:commands].each do |k,v|
        print "#{k} \n"
      end
    else
      File.open( @config_yaml[:output_log], 'a') {|f| f
          .write("#{Time.now.strftime('%H:%M')
          } > #{caught_command[0]
          } < command executed. Arguments: #{
          @@caught_arguments if @@caught_arguments }\n")}
      print "-> Answer:\n"
    end

    if @@caught_arguments == '--help'
      puts caught_class.description
    elsif @@caught_arguments == '--all' && caught_class == HelpCommand
      say
      @config_yaml[:commands].each do |k,v|
        print "#{k}: #{v} \n"
      end
    else
      begin
        caught_class.run
      rescue my_error_method( @config_yaml[:debug] ) => e
        File.open( @config_yaml[:error_log], 'a') {|f| f.write("#{
        Time.now.strftime('%H:%M') }: #{ caught_command[0] }: #{
        @debug_mode_option ? e.backtrace : e.message } \n")}
      end
    end
  end

  def self.say(*args)
    print "Time now --> #{Time.now}\n"
    print "Program name --> #{$0}\n"
    if args != []
      puts " > Hello from Command.say method:)\n > #{args}\n"
    else
      puts " > Hello from Command.say method:)\n"
    end
  end
end

class HelpCommand < Command
  class << self
    def name
      'help'
    end

    def description
      'type \'command_name --help\' to see description'
    end

    def run
      say ('List of commands')
      Command::ALL_COMMANDS.each { |cmd| puts "#{ cmd.name }"}
      puts " > for full help type 'help --all'"
    end
  end
end

class UpTimeCommand < Command
  class << self
    def name
      'uptime'
    end

    def description
      'will give you OS uptime'
    end

    def run
      uptime_file = '/proc/uptime'
      time = IO.read( uptime_file ).split[0].to_i
      hours = (IO.read( uptime_file ).split[0].to_i) / 3600
      minutes = (time - hours * 3600) / 60
      seconds = time - hours * 3600 - minutes * 60
      puts "#{hours}h #{minutes}min #{seconds}sec"
    rescue Errno::ENOENT => e
      File.open( @config_yaml[:error_log], 'a') {|f| f.write("#{ Time
          .now.strftime('%H:%M') }: #{ @debug_mode_option ?
          e.backtrace : e.message }\n")}
      puts e.message
    end
  end
end

class DateCommand < Command
  class << self
    def name
      'date'
    end

    def description
      'prints today\'s date'
    end

    def run
      puts Time.now.strftime('%d/%m/%Y %H:%M')
    end
  end
end

class EchoCommand < Command
  class<< self
    def name
      'echo'
    end

    def description
      'echo you args'
    end

    def run
      if @@caught_arguments
        puts "#{ @@caught_arguments }"
      else
        print " > print message to echo:\n"
        words = $stdin.gets.chomp.split
        puts " > #{ words[0] }"
      end
    end
  end
end

class PingCommand < Command
  class << self
    def name
      'ping'
    end

    def description
      'to ping everything'
    end

    def run( ping_count: 4)
      if @@caught_arguments
        puts " > please wait ...\n\n"
        puts `ping -q -c #{ ping_count } #{ @@caught_arguments }`
        if $?.exitstatus == 0
          puts "\n > #{ @@caught_arguments } is up!\n\n"
        end
      else
        puts ' > Please, enter host name to ping'
        servername = $stdin.gets.chomp.split
        puts " > please wait...\n\n"
        puts `ping -q -c #{ ping_count } #{ servername[0]}`
        if $?.exitstatus == 0
          puts "\n > #{servername[0]} is up!\n\n"
        end
      end
    end
  end
end

puts " Hello, #{ ENV['USER']}! Welcome to ruby console.
 Enter you command, or 'help' to get help
 To exit Ctrl+D, Ctrl+C or exit"
Command::ALL_COMMANDS.push(HelpCommand, UpTimeCommand, DateCommand,
                           EchoCommand, PingCommand)
while true
  Command.command_by_name
end
