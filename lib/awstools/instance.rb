require 'erb'

class Awstools::Instance
  def initialize(options)
    @options = options
    @compute = Fog::Compute.new(
      :provider => 'AWS',
      :region => @options['region'],
      :aws_access_key_id => @options['access_key_id'],
      :aws_secret_access_key => @options['access_key'],
    )
  end

  def launch
    @instance = @compute.servers.create(
      image_id:  @options['image-id'],
      flavor_id: @options['instance-type'],
      security_group_ids: @options['security-group-ids'],
      subnet_id: @options['subnet-id'],
      key_name: @options['key-name'],
      tags: @options['tags'],
      user_data: ERB.new(File.read(@options['userdata'])).result
    )
    @instance.wait_for { ready? }
    pp @instance.reload
  end

  def set_dns
    dns = Fog::DNS.new(
      :provider => 'AWS',
      :aws_access_key_id => @options['access_key_id'],
      :aws_secret_access_key => @options['access_key'],
    )

    zone = dns.zones.get(@options['dns-zone-id'])

    @record = zone.records.create(
      value: @instance.private_ip_address,
      name: @options['hostname'],
      type: 'A'
    )
  end
end
