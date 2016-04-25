#!/home/pavel_busko/.rvm/rubies/ruby-2.3.0/bin/ruby

require 'net/ping'
require 'yaml'
trap('SIGINT') {puts "\nGood bye!"; exit 0}
conf = Hash[ ARGV.join(' ').scan(/--?([^=\s]+)(?:=(\S+))?/) ]
if conf['config'].nil?
  yaml_file = 'pavel_busko_l5.yml'
else
  yaml_file = conf['config']
end
if File.exist?(yaml_file)
  CONF = YAML.load_file(yaml_file)
  DEB = CONF['debug']
else
  puts "\nConfig file not found. Using default parameters..."
  CONF = {output: 'pavel_busko_l5.log',
          error: 'pavel_busko_l5_errors.log',
          commands:
              {help: 'Help command provides you list of available commands',
               uptime: 'Uptime commands gives you current machine uptime',
               date: 'Date command shows current date/time',
               ping: 'Check if server is accessible',
               echo: 'Echo command echoes the first argument passed by command'}}
  DEB = false
end
class Command
  ALL_COMMANDS = []
  def self.inherited(cls)
    ALL_COMMANDS.push(cls)
  end

  def self.say(args)
    print Time.now, ' ', $0, ' params -  ', args, "\n\n"
  end

  def self.check(*args)
    command_need = ALL_COMMANDS.detect { |cmd| cmd.name.downcase == args[0].downcase }
    command_need.run(args[1])
  end
end
class HelpCommand < Command
  def self.name
    'help'
  end

  def self.description
    CONF['commands']['help']
  end

  def self.run(arg)
    say(arg)
    out = File.open(CONF['output'], 'a')
    out.write("#{Time.now.strftime('%H:%M:%S %d.%m.%y')}: command - #{name}\n")
    Command::ALL_COMMANDS.each do |cmd|
      out.write("\t#{cmd.name} - #{cmd.description}\n")
      puts "#{cmd.name} - #{cmd.description}"
    end
    out.close
  end
end
class UptimeCommand < Command
  def self.name
    'uptime'
  end

  def self.description
    CONF['commands']['uptime']
  end

  def self.run(arg)
    say(arg)
    out = File.open(CONF['output'], 'a')
    out.write("#{Time.now.strftime('%H:%M:%S %d.%m.%y')}: command - #{name}\n")
    uptime = File.read('/proc/uptime').split[0].to_i
    out.write("\tUptime is #{Time.at(uptime).utc.strftime('%Hh %Mm %Ss')}\n")
    puts "Uptime is #{Time.at(uptime).utc.strftime('%Hh %Mm %Ss')}"
    out.close
  end
end
class DateCommand < Command
  def self.name
    'date'
  end

  def self.description
    CONF['commands']['date']
  end

  def self.run(arg)
    say(arg)
    out = File.open(CONF['output'], 'a')
    out.write("#{Time.now.strftime('%H:%M:%S %d.%m.%y')}: command - #{name}\n")
    out.write("\tCurrent date and time - #{Time.now}\n")
    puts "Current date and time - #{Time.now}"
    out.close
  end
end
class EchoCommand < Command
  def self.name
    'echo'
  end

  def self.description
    CONF['commands']['echo']
  end

  def self.run(arg)
    say(arg)
    out = File.open(CONF['output'], 'a')
    out.write("#{Time.now.strftime('%H:%M:%S %d.%m.%y')}: command - #{name} - #{arg}\n")
    out.write("\t#{arg}\n")
    puts arg
    out.close
  end
end
class PingCommand < Command
  def self.name
    'ping'
  end

  def self.description
    CONF['commands']['ping']
  end

  def self.run(address)
    say(address)
    out = File.open(CONF['output'], 'a')
    out.write("#{Time.now.strftime('%H:%M:%S %d.%m.%y')}: command - #{name} - #{address}\n")
    out.write("\t#{Net::Ping::External.new(address).ping?}\n")
    puts Net::Ping::External.new(address).ping?
    out.close
  end
end
def log_mode(exc)
    $stderr = File.open(CONF['error'], 'a')
    $stderr.puts "#{exc.class} - #{exc.exception} - #{exc.backtrace if DEB}"
    $stderr.close
    puts "#{exc.class} - #{exc.message} - #{exc.backtrace if DEB}"
end
puts '*******************************************'
puts '*                                         *'
puts '*              BEAUTIFUL CMD              *'
puts '*                                         *'
puts '*******************************************'
puts 'type "help" to check out available commands'
puts 'type "exit" to exit the command line'
puts "debug status is #{DEB}"
print "\n"
loop do
  print '=> '
  a = $stdin.gets
  if a.chomp.split[0] == 'exit'
    puts 'Good bye!'
    exit 0
  elsif
    a == "\n"
    next
  else
    begin
      Command.check(*(a.chomp.split))
    rescue NoMethodError => exc
      puts 'Wrong command. Type "help" to see available commands'
      log_mode(exc)
    rescue StandardError => exc
      log_mode(exc)
    end
  end
end