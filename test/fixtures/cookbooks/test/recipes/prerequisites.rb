execute 'apt-get update' if platform_family?('debian')

unless platform_family?('windows')
  splunk_app 'bistro' do
    app_name 'bistro'
    if node['platform_family'] == 'windows'
      splunk_auth 'admin:changeme'
    else
      splunk_auth 'admin:notarealpassword'
    end
    cookbook_file 'bistro-1.0.2.spl'
    checksum '862e2c4422eee93dd50bd93aa73a44045d02cb6232f971ba390a2f1c15bdb79f'
    action [:install, :enable]
  end
end
  splunk_app 'bistro-1.0.2' do
    remote_file 'https://github.com/ampledata/bistro/archive/1.0.2.tar.gz'
    if node['platform_family'] == 'windows'
      splunk_auth 'admin:changeme'
    else
      splunk_auth 'admin:notarealpassword'
    end
    # app_dependencies(
    #   if node['platform_family'] == 'omnios'
    #     ['ruby-19']
    #   else
    #     ['ruby']
    #   end
    # )
    action :install
  end
splunk_app 'test' do
  app_name 'test'
  if node['platform_family'] == 'windows'
    splunk_auth 'admin:changeme'
  else
    splunk_auth 'admin:notarealpassword'
  end
  cookbook_file 'test-0.0.1.spl'
  action [:install, :enable]
end

splunk_app 'sanitycheck' do
  remote_directory 'sanitycheck'
  if node['platform_family'] == 'windows'
    splunk_auth 'admin:changeme'
  else
    splunk_auth 'admin:notarealpassword'
  end
  action :install
end

splunk_app 'sanitycheck2' do
  app_name 'sanitycheck2'
  remote_directory 'sanitycheck'
  if node['platform_family'] == 'windows'
    splunk_auth 'admin:changeme'
  else
    splunk_auth 'admin:notarealpassword'
  end
  action :install
end

if platform_family?('windows')
  splunk_app 'windowseventlog_inputs' do
    splunk_auth 'admin:changeme'
    templates ['inputs.conf']
    template_cookbook 'test'
    action :install
  end
else
  splunk_app 'generallogs_inputs' do
    splunk_auth 'admin:notarealpassword'
    templates ['inputs.conf']
    template_cookbook 'test'
    action :install
  end
end
