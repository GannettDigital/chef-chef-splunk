require 'spec_helper'

if ENV['OS'] == 'Windows_NT'
  splunk_base_dir = 'C:/Program Files/SplunkUniversalForwarder'
  splunk_command = 'C:\\"Program Files"\\SplunkUniversalForwarder\\bin\\splunk'
else
  splunk_base_dir = '/opt/splunkforwarder'
  splunk_command = "#{splunk_base_dir}/bin/splunk"
end
describe file("#{splunk_base_dir}/bin/") do
  it { should exist }
  it { should be_a_directory }
end

describe file("#{splunk_base_dir}/bin/splunk") do
  it { should exist }
  it { should be_executable }
end

describe service("#{$node['splunk']['service']}") do
  it { should be_running }
  it { should be_enabled }
end

describe 'inputs config should be configured per node attributes' do
  describe file("#{splunk_base_dir}/etc/system/local/inputs.conf") do
    it { should be_file }
    its(:content) { should match(/\[tcp:\/\/:123123\]/) }
    its(:content) { should match(/connection_host = dns/) }
    its(:content) { should match(/sourcetype = syslog/) }
    its(:content) { should match(/source = tcp:123123/) }
  end
end

describe 'outputs config should be configured per node attributes' do
  describe file("#{splunk_base_dir}/etc/system/local/outputs.conf") do
    it { should be_file }
    its(:content) { should match(/defaultGroup=#{$node['splunk']['indexers_group1']['name']},#{$node['splunk']['indexers_group2']['name']}/) }
    # from the default attributes
    its(:content) { should match(/forwardedindex.0.whitelist = .*/) }
    its(:content) { should match(/forwardedindex.1.blacklist = _.*/) }
    its(:content) { should match(/forwardedindex.2.whitelist = _audit/) }
    its(:content) { should match(/forwardedindex.filter.disable = false/) }
    # tcpout
    its(:content) { should match(/tcpout:#{$node['splunk']['indexers_group1']['name']}/) }
    its(:content) { should match(/tcpout:#{$node['splunk']['indexers_group2']['name']}/) }
    # ['indexers_group1']['splunk_servers']
    its(:content) { should match(/server=#{$node['splunk']['indexers_group1']['splunk_servers']}/) }
    # ['indexers_group2']['splunk_servers']
    its(:content) { should match(/server=#{$node['splunk']['indexers_group2']['splunk_servers']}/) }
    # attributes for dynamic definition
    its(:content) { should match(/sslCertPath = \$SPLUNK_HOME\/etc\/certs\/cert.pem/) }
    its(:content) { should match(/sslCommonNameToCheck = sslCommonName/) }
    its(:content) { should match(/sslRootCAPath = \$SPLUNK_HOME\/etc\/certs\/cacert.pem/) }
    its(:content) { should match(/sslVerifyServerCert = false/) }
  end
end

