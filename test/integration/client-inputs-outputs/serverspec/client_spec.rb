require 'spec_helper'

if ENV['OS'] == 'Windows_NT'
  splunk_base_dir = 'C:/Program Files/SplunkUniversalForwarder'
  splunk_command = 'C:\\"Program Files"\\SplunkUniversalForwarder\\bin\\splunk'
else
  splunk_base_dir = '/opt/splunkforwarder'
  splunk_command = "#{splunk_base_dir}/bin/splunk"
end

describe file('#{splunk_base_dir}/bin/') do
  it { should exist }
  it { should be_a_directory }
end

describe file('#{splunk_base_dir}/bin/splunk') do
  it { should exist }
  it { should be_executable }
end

describe service('splunk') do
  it { should be_running }
  it { should be_enabled }
end

describe process('splunkd') do
  its(:user) { should match 'root' }
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
    if ENV['OS'] == 'Windows_NT'
      its(:content) { should match(/defaultGroup=cloned_group1/) }
      its(:content) { should match(/disabled=false/) }

      its(:content) { should match(/forwardedindex.1.blacklist = _.*/) }
      its(:content) { should match(/forwardedindex.2.whitelist = _audit/) }
      its(:content) { should match(/forwardedindex.filter.disable = false/) }
    else
      its(:content) { should match(/defaultGroup = splunk_indexers_9997/) }
      # from the default attributes
      its(:content) { should match(/forwardedindex.0.whitelist = .*/) }
      its(:content) { should match(/forwardedindex.1.blacklist = _.*/) }
      its(:content) { should match(/forwardedindex.2.whitelist = _audit/) }
      its(:content) { should match(/forwardedindex.filter.disable = false/) }
      # servers
      its(:content) { should match(/server = 10.0.2.47:9997/) }
      # attributes for dynamic definition
      its(:content) { should match(/sslCertPath = \$SPLUNK_HOME\/etc\/certs\/cert.pem/) }
      its(:content) { should match(/sslCommonNameToCheck = sslCommonName/) }
      # it won't be the plaintext 'password' per the attribute, and may
      # differ due to salt, just make sure it looks passwordish.
      its(:content) { should match(/sslPassword = \$1/) }
      its(:content) { should match(/sslRootCAPath = \$SPLUNK_HOME\/etc\/certs\/cacert.pem/) }
      its(:content) { should match(/sslVerifyServerCert = false/) }
    end
  end
end
