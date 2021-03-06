require 'spec_helper'

if ENV['OS'] == 'Windows_NT'
  splunk_base_dir = 'C:/Program Files/SplunkUniversalForwarder'
  splunk_command = 'C:\\"Program Files"\\SplunkUniversalForwarder\\bin\\splunk.exe'
  describe file("#{splunk_base_dir}/bin/splunk.exe") do
    it { should exist }
  end
else
  splunk_base_dir = '/opt/splunkforwarder'
  splunk_command = "#{splunk_base_dir}/bin/splunk"
  describe file("#{splunk_command}") do
    it { should exist }
    it { should be_executable }
  end
end
describe file("#{splunk_base_dir}/bin/") do
  it { should exist }
  it { should be_directory }
end

describe service("#{$node['splunk']['service']}") do
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
    its(:content) { should match(/defaultGroup = #{$node['splunk']['indexers_group1']['name']}, #{$node['splunk']['indexers_group2']['name']}/) }
    # from the default attributes
    its(:content) { should match(/forwardedindex.0.whitelist = .*/) }
    its(:content) { should match(/forwardedindex.1.blacklist = _.*/) }
    its(:content) { should match(/forwardedindex.2.whitelist = _audit/) }
    its(:content) { should match(/forwardedindex.filter.disable = false/) }
    # tcpout
    its(:content) { should match(/[tcpout:#{$node['splunk']['indexers_group1']['name']}]/) }
    its(:content) { should match(/[tcpout:#{$node['splunk']['indexers_group2']['name']}]/) }
    # ['indexers_group1']['splunk_servers']
    its(:content) { should match(/server = #{$node['splunk']['indexers_group1']['splunk_servers']}/) }
    # ['indexers_group2']['splunk_servers']
    its(:content) { should match(/server = #{$node['splunk']['indexers_group2']['splunk_servers']}/) }
    # attributes for dynamic definition
    its(:content) { should match(/sslCertPath = \$SPLUNK_HOME\/etc\/certs\/cert.pem/) }
    its(:content) { should match(/sslCommonNameToCheck = sslCommonName/) }
    its(:content) { should match(/sslRootCAPath = \$SPLUNK_HOME\/etc\/certs\/cacert.pem/) }
    its(:content) { should match(/sslVerifyServerCert = false/) }
  end
end

describe 'splunk app bistro 1.0.3 should be installed' do
  describe file("#{splunk_base_dir}/etc/apps/bistro/default/app.conf") do
    it { should exist }
    it { should be_file }
    its(:content) { should match(/version = 1.0.3/) }
    its(:content) { should match(/id = bistro/) }
  end
  describe command('/opt/splunkforwarder/bin/splunk btool --app=bistro app list') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should_not match /disabled\s*=\s*(0|false)/ }
  end
end

describe 'splunk app sanitycheck should be installed' do
  describe file("#{splunk_base_dir}/etc/apps/sanitycheck") do
    it { should exist }
    it { should be_directory}
  end
end

describe 'splunk app sanitycheck2 should be removed' do
  describe file("#{splunk_base_dir}/etc/apps/sanitycheck2") do
    it { should_not exist }
  end
end

describe 'splunk app bistro-1.0.2 should be removed' do
  describe file("#{splunk_base_dir}/etc/apps/bistro-1.0.2") do
    it { should_not exist }
  end
end

describe 'splunk app test 0.0.2 should be installed' do
  describe file("#{splunk_base_dir}/etc/apps/test/default/app.conf") do
    it { should exist }
    it { should be_file }
    its(:content) { should match(/version = '0.0.2'/) }
  end
  describe command("#{splunk_base_dir}/bin/splunk btool --app=test app list") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should_not match /disabled\s*=\s*(0|false)/ }
  end
end

describe 'splunk app generallogs_inputs should be installed' do
  describe file("#{splunk_base_dir}/etc/apps/generallogs_inputs/local/inputs.conf") do
    it { should exist }
    it { should be_file }
    its(:content) { should match(/index = main/) }
    its(:content) { should match(/sourcetype=syslog/) }
    its(:content) { should match(/disabled = 0/) }
  end
  describe command("#{splunk_base_dir}/bin/splunk btool --app=generallogs_inputs app list") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should_not match /disabled\s*=\s*(0|false)/ }
  end
  describe package('splunkforwarder') do
    it { should be_installed }
    it { should be_installed.with_version($node['splunk']['forwarder']['package_version']) } unless $node['splunk']['forwarder']['package_version'].nil?
  end
  describe command('yum list splunkforwarder') do
    its(:stdout) { should match /gdcustom/ }
  end
end
