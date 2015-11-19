execute 'apt-get update' if platform_family?('debian')

splunk_app 'nginxlogs_inputs' do
  splunk_auth 'admin:changeme'
  cookbook_file 'nginxlogs_inputs-0.0.2.spl'
  action [:install, :enable]
end

splunk_app 'nginxlogs_inputs-disable' do
  app_name 'nginxlogs_inputs'
  splunk_auth 'admin:changeme'
  action [:disable, :remove]
end

splunk_app 'sanitycheck' do
  remote_directory 'sanitycheck'
  splunk_auth 'admin:changeme'
  action :install
end

splunk_app 'nginxlogs_inputs-remote-file' do
  app_name 'nginxlogs_inputs-0.0.2'
  remote_file 'http://artifactory-scalr.tools.gannettdigital.com/artifactory/splunk-apps/nginxlogs_inputs/nginxlogs_inputs-0.0.2.spl'
  splunk_auth 'admin:changeme'
  action :install
end
