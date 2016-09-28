require 'optparse'
require 'psych'

class Awstool::Settings
  @options = {}

  attr_reader :options

  def self.get_options
    set_default
    get_rc
    get_flags
    @options
  end

  private 

  def self.get_flags
    OptionParser.new do |opts|
      opts.banner = 'Usage: awstool [options] hostname'

      opts.on('-h', '--help', 'Prints this help') do
        puts opts
        exit
      end

      opts.on('-f', '--facts FACT1,FACT2', Array, 'Seed new instance with puppet facts') do |facts|
        facts.each do |fact|
          split_fact = fact.split('=')
          @options['facts'][split_fact[0]] = split_fact[1]
        end
      end

      opts.on('-t', '--tags TAG1,TAG2', Array, 'Set EC2 instance tags') do |tags|
        tags.each do |tag|
          split_tag = tag.split('=')
          @options['tags'][split_tag[0]] = split_tag[1]
        end
      end

      opts.on('--debug', 'Prints some extra output helpful for debugging') do
        @options['debug'] = true
      end
    end.parse!

    [ 'hostname' ].each do |v|
      if ARGV.empty?
        puts "#{v} string is required."
        exit 1
      else
        @options[v] = ARGV.shift
      end
    end
    @options['tags']['Name'] = @options['hostname']
  end

  def self.get_rc
    awsconf = "#{ENV['HOME']}/.awstool.yaml"
    if File.exist?(awsconf)
      @options.merge!(Psych.load_file(awsconf))
    end
  end

  def self.set_default
    @options['userdata'] = File.expand_path('../userdata/default.erb')
    @options['facts'] = {}
    @options['tags']= {}
  end
end
