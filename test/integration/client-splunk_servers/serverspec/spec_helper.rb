require 'serverspec'
require 'pathname'
require 'json'

if ENV['OS'] == 'Windows_NT'
  set :backend, :cmd
  # On Windows, set the target host's OS explicitely
  set :os, :family => 'windows'
else
  set :backend, :exec
end

set :path, '/sbin:/usr/local/sbin:$PATH' unless os[:family] == 'windows'
