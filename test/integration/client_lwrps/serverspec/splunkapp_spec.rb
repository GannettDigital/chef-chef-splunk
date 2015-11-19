require 'spec_helper'

if ENV['OS'] == 'Windows_NT'
  splunk_base_dir = 'C:/Program Files/SplunkUniversalForwarder'
  splunk_command = 'C:\\"Program Files"\\SplunkUniversalForwarder\\bin\\splunk'
else
  splunk_base_dir = '/opt/splunkforwarder'
  splunk_command = "#{splunk_base_dir}/bin/splunk"
end

describe 'splunk apps should be installed and enabled' do
  describe file("#{splunk_base_dir}/etc/apps/nginxlogs_inputs-0.0.2") do
    it { should exist }
    it { should be_directory }
    it { should be_owned_by 'splunk' } unless ENV['OS'] == 'Windows_NT'
  end
  describe command("#{splunk_command} btool --app=nginxlogs_inputs-0.0.2 app list") do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should_not match /disabled\s*=\s*(0|false)/ }
  end
end
