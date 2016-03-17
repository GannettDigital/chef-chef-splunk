splunk_app 'test-upgrade' do
  app_name 'test'
  if node['platform_family'] == 'windows'
    splunk_auth 'admin:changeme'
  else
    splunk_auth 'admin:notarealpassword'
  end
  cookbook_file 'test-0.0.2.spl'
  action [:install, :enable]
end

splunk_app 'sanitycheck2-delete' do
  app_name 'sanitycheck2'
  if node['platform_family'] == 'windows'
    splunk_auth 'admin:changeme'
  else
    splunk_auth 'admin:notarealpassword'
  end
  action :remove
end

splunk_app 'bistro-upgrade' do
  app_name 'bistro'
  if node['platform_family'] == 'windows'
    splunk_auth 'admin:changeme'
    notifies :restart, "service[#{node['splunk']['service']}]", :delayed
  else
    splunk_auth 'admin:notarealpassword'
  end
  cookbook_file 'bistro-1.0.3.spl'
  action [:install, :enable]
end
splunk_app 'bistro-remote-file-delete' do
  app_name 'bistro-1.0.2'
  if node['platform_family'] == 'windows'
    splunk_auth 'admin:changeme'
  else
    splunk_auth 'admin:notarealpassword'
  end
  action :remove
end
