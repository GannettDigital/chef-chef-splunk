require 'spec_helper'

describe 'inputs config should be configured per node attributes' do
  describe file('/opt/splunkforwarder/etc/system/local/inputs.conf') do
    it { should be_file }
    its(:content) { should match(/\[tcp:\/\/:123123\]/) }
    its(:content) { should match(/connection_host = dns/) }
    its(:content) { should match(/sourcetype = syslog/) }
    its(:content) { should match(/source = tcp:123123/) }
  end

  describe file('/opt/splunkforwarder/etc/splunk-launch.conf') do
    it { should be_file }
    its(:content) { should contain("SPLUNK_HOME=/opt/splunkforwarder") }
    its(:content) { should contain("SPLUNK_SERVER_NAME=SplunkForwarder") }
    its(:content) { should contain("SPLUNK_WEB_NAME=splunkweb") }
    its(:content) { should contain("MONGOC_DISABLE_SHM=1") }
    its(:content) { should contain("SPLUNK_ENVIRONMENT=development") }
  end

  describe command('/opt/splunkforwarder/bin/splunk envvars') do
    its(:stdout) { should contain("SPLUNK_ENVIRONMENT=development ; export SPLUNK_ENVIRONMENT") }
  end
end

describe 'outputs config should be configured per node attributes' do
  describe file('/opt/splunkforwarder/etc/system/local/outputs.conf') do
    it { should be_file }
    its(:content) { should match(/defaultGroup=cloned_group1,cloned_group2/) }
    # from the default attributes
    its(:content) { should match(/forwardedindex.0.whitelist = .*/) }
    its(:content) { should match(/forwardedindex.1.blacklist = _.*/) }
    its(:content) { should match(/forwardedindex.2.whitelist = _audit/) }
    its(:content) { should match(/forwardedindex.filter.disable = false/) }
    # tcpout
    its(:content) { should match(/tcpout:cloned_group1/) }
    its(:content) { should match(/tcpout:cloned_group2/) }
    # servers
    its(:content) { should match(/server=192.168.10.1:9997, 192.168.10.2:9997, 192.168.10.3:9997/) }
    # attributes for dynamic definition
    its(:content) { should match(/sslCertPath = \$SPLUNK_HOME\/etc\/certs\/cert.pem/) }
    its(:content) { should match(/sslCommonNameToCheck = sslCommonName/) }
    its(:content) { should match(/sslRootCAPath = \$SPLUNK_HOME\/etc\/certs\/cacert.pem/) }
    its(:content) { should match(/sslVerifyServerCert = false/) }
  end
end
