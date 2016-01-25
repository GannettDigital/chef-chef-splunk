require 'spec_helper'

describe 'splunk apps should be installed and enabled' do
  describe file('/opt/splunk/etc/apps/bistro-1.0.2') do
    it { should exist }
    it { should be_directory }
    it { should be_owned_by 'splunk' }
  end
  describe command('/opt/splunk/bin/splunk btool --app=bistro-1.0.2 app list') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should_not match /disabled\s*=\s*(0|false)/ }
  end
end

describe 'chef-splunk::server should run as "root" user' do
  describe command('ps aux | grep "splunkd -p" | head -1 | awk \'{print $1}\'') do
    its(:stdout) { should match(/root/) }
  end
end

describe 'chef-splunk::server should listen on web_port 443' do
  describe port(443) do
    it { should be_listening.with('tcp') }
  end
end