# Awstool

Tool for launching and configuring AWS EC2 instances.

## Installation

```bash
gem install awstool
```

## Usage

Copy example/awstools.yaml to ~/.awstools.yaml. Fill it out to your liking.
```bash
awstool floop.example.com
```
This will launch and instance and create an A record with route53.
You can split your settings files up and then merge them on the command line with the -o flag.
```bash
awstool -o ~/ubuntu-14.04.yaml,~/webserver.yaml floop.example.com
```
This will allow for different levels of templating. Particularly useful for setting puppet 
options and security groups. Launch a bunch of instances off of the same configs like so.
```bash
awstool -o ~/ubuntu-14.04.yaml,~/webserver.yaml floop1.example.com floop2.example.com jb.example.com
# or
awstool -o ~/ubuntu-14.04.yaml,~/webserver.yaml floop{1..5}.example.com
```
When launching multiple instances the tool will choose a random subnet from the subnet-ids array unless
the -s flag or the 'subnet-id-index' option is set. It can also balance between the subnets with
'subnet_balance: true' in settings.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nburg/awstools.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

