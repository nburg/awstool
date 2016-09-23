# Awstools

Tool for launching and configuring AWS EC2 instances.

## Installation

Not properly gemmed up yet. You'll need to clone and set RUBYLIB environment variable to clonepath/awstools/lib. Requires the fog gem and ruby >=1.9.3.
```bash
export RUBYLIB=/home/user/repos/awstools/lib
sudo apt-get install ruby-dev # For ubuntu/debian
gem install fog
```

## Usage

Copy example/awstools.yaml to ~/.awstools.yaml. Fill it out to your liking.
```bash
cd awstools/bin
./awstools hostname
```
This will launch and instance and create an A record with route53. 


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nburg/awstools.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

