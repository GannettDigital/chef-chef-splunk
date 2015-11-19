#
# Cookbook Name:: splunk
# Libraries:: helpers
#
# Author: Joshua Timberman <joshua@chef.io>
# Copyright (c) 2014, Chef Software, Inc <legal@chef.io>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

def splunk_file(uri)
  require 'pathname'
  require 'uri'
  Pathname.new(URI.parse(uri).path).basename.to_s
end

def splunk_cmd
  if node['platform_family'] == 'windows'
    node['kernel']['os_info']['system_drive'] + '\\"Program Files"\\SplunkUniversalForwarder\\bin\\splunk'
  else
    "#{splunk_dir}/bin/splunk"
  end
end

def splunk_dir
  # Splunk Enterprise (Server) will install in /opt/splunk.
  # Splunk Universal Forwarder can be a used as a client or a forwarding
  # (intermediary) server which installs to /opt/splunkforwarder
  if node['platform_family'] == 'windows'
    forwarderpath = "#{node['kernel']['os_info']['system_drive']}\\Program Files\\SplunkUniversalForwarder"
    enterprisepath = "#{node['kernel']['os_info']['system_drive']}\\Program Files\\SplunkUniversalForwarder"
  else
    forwarderpath = '/opt/splunkforwarder'
    enterprisepath = '/opt/splunk'
  end

  if node['splunk']['is_intermediate'] == true
    path = forwarderpath
    return path
  elsif node['splunk']['is_server'] == true
    path = enterprisepath
    return path
  else
    path = forwarderpath
    return path
  end
end

def splunk_auth(auth)
  # if auth is a string, we assume it's correctly
  # defined as a splunk authentication string, like:
  #
  # admin:changeme
  #
  # if it is an array, we assume it has two elements that should be
  # joined with a : to make it defined as a splunk authentication
  # string (as above.
  case auth
  when String
    auth
  when Array
    auth.join(':')
  end
end
