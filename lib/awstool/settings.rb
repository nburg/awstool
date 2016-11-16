require 'optparse'
require 'psych'

class Awstool::Settings
  @options = {}
  @option_files = []

  attr_reader :options

  def self.get_options
    set_default
    get_rc
    get_flags
    @option_files.each do |f|
      @options.merge!(f)
    end
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
          @options['facts'][split_fact.first] = split_fact[1]
        end
      end

      opts.on('-t', '--tags TAG1,TAG2', Array, 'Set EC2 instance tags') do |tags|
        tags.each do |tag|
          split_tag = tag.split('=')
          @options['tags'][split_tag.first] = split_tag[1]
        end
      end

      opts.on('--debug', 'Prints some extra output helpful for debugging') do
        @options['debug'] = true
      end

      opts.on('-s', '--subnet-id-index INDEX', 'Select a subnet-id from you subnet-ids array.') do |index|
        @options['subnet-id-index'] = index.to_i
      end

      opts.on(
        '-o',
        '--options-file FILE1,FILE2',
        Array,
        'List option files that will merge and override settings in .awstool.yaml. Last entry takes precedence.' ) do |of|
        of.each do |f|
          @option_files << Psych.load_file(File.expand_path(f))
        end
      end

    end.parse!

    if ARGV.empty?
      puts "hostname string is required."
      exit 1
    else
      @options['hostnames'] = ARGV
    end
  end

  def self.get_rc
    awsconf = "#{ENV['HOME']}/.awstool.yaml"
    if File.exist?(awsconf)
      @options.merge!(Psych.load_file(awsconf))
    end
    @options['subnet-id-index'] = rand(@options['subnet-ids'].length - 1 )
  end

  def self.set_default
    @options['userdata'] = File.expand_path(File.dirname(__FILE__)) + '/../../userdata/default.erb'
    @options['facts'] = {}
    @options['tags']= {}
    @options['hostnames'] = []
    @options['rootvol_size'] = 8
    @options['block_devices'] = false
    @options['timezone'] = 'UTC'
  end
end
