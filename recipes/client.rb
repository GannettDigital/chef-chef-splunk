#
# Cookbook Name:: splunk
# Recipe:: client
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
# This recipe encapsulates a completely configured "client" - a
# Universal Forwarder configured to talk to a node that is the splunk
# server (with node['splunk']['is_server'] true). The recipes can be
# used on their own composed in your own wrapper cookbook or role.
include_recipe 'chef-splunk::user'
include_recipe 'chef-splunk::install_forwarder'

if node['splunk']['indexers_group1']['splunk_servers'].empty?
  node['splunk']['indexers_group1']['splunk_servers'] == search( # ~FC003
    :node,
    "splunk_is_server:true AND chef_environment:#{node.chef_environment}"
  ).sort! do |a, b|
    a.name <=> b.name
  end
end

# ensure that the splunk service resource is available without cloning
# the resource (CHEF-3694). this is so the later notification works,
# especially when using chefspec to run this cookbook's specs.
begin
  resources("service[#{node['splunk']['service']}]")
rescue Chef::Exceptions::ResourceNotFound
  service 'splunk' unless platform_family?('windows')
  service 'SplunkForwarder' if platform_family?('windows')
end

directory "#{splunk_dir}/etc/system/local" do
  recursive true
  owner node['splunk']['user']['username']
  group node['splunk']['user']['username']
end

template "#{splunk_dir}/etc/system/local/outputs.conf" do
  source 'outputs.conf.erb'
  mode 0644
  variables(
    :indexers_group1_name => node['splunk']['indexers_group1']['name'],
    :indexers_group1_splunk_servers => node['splunk']['indexers_group1']['splunk_servers'],
    :indexers_group1_outputs_conf => node['splunk']['indexers_group1']['outputs_conf'],
    :indexers_group2_name => node['splunk']['indexers_group2']['name'],
    :indexers_group2_splunk_servers => node['splunk']['indexers_group2']['splunk_servers'],
    :indexers_group2_outputs_conf => node['splunk']['indexers_group2']['outputs_conf']
  )
  notifies :restart, "service[#{node['splunk']['service']}]"
end

template "#{splunk_dir}/etc/system/local/inputs.conf" do
  source 'inputs.conf.erb'
  mode 0644
  variables :inputs_conf => node['splunk']['inputs_conf']
  notifies :restart, "service[#{node['splunk']['service']}]"
  not_if { node['splunk']['inputs_conf'].nil? || node['splunk']['inputs_conf']['host'].empty? }
end

template "#{splunk_dir}/etc/apps/SplunkUniversalForwarder/default/limits.conf" do
  source 'limits.conf.erb'
  mode 0644
  variables :ratelimit_kbps => node['splunk']['ratelimit_kilobytessec']
  notifies :restart, "service[#{node['splunk']['service']}]"
end

template "#{splunk_dir}/etc/splunk-launch.conf" do
  source 'splunk-launch.conf.erb'
  mode 0644
  variables(
    :environment => node['splunk']['environment'],
    :splunkhome =>  splunk_dir
  )
  notifies :restart, "service[#{node['splunk']['service']}]"
end

include_recipe 'chef-splunk::service'
include_recipe 'chef-splunk::setup_auth' if node['splunk']['setup_auth']
