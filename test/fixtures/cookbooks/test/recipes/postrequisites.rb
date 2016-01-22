splunk_app 'bistro-1.0.2-upgrade-to-1.0.3' do
  app_name 'bistro'
  splunk_auth 'admin:changeme'
  cookbook_file 'bistro-1.0.3.spl'
  action [:install, :enable]
end

splunk_app 'sanitycheck-remote-directory-delete' do
  app_name 'sanitycheck-remote-directory'
  splunk_auth 'admin:changeme'
  action :remove
end

splunk_app 'bistro-delete' do
  app_name 'bistro-1.0.2'
  splunk_auth 'admin:changeme'
  action :remove
end