#
# Cookbook Name:: jboss
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node.override['java']['install_flavor'] = "oracle"
node.override['java']['jdk_version'] = "6"
node.override['java']['oracle']['accept_oracle_download_terms'] = true

include_recipe 'java'

package "unzip" do
  action :install
end

user node['jboss']['jboss_user'] do
  comment 'jboss user'
  home node['jboss']['jboss_home']
  system true
  shell '/bin/bash'
  password '$1$vbM1Ln9u$xQ1f1RdFUyJsuXp4sKpZs.'
end

group node['jboss']['jboss_group'] do
  action :create
end

remote_file "#{ node['jboss']['tmp_dir'] }/jboss-5.1.0.GA.zip" do
  source node['jboss']['url']
  owner node['jboss']['jboss_user']
  group node['jboss']['jboss_group']
  mode '0755'
  action :create
  not_if { ::File.exists?("#{ node['jboss']['tmp_dir'] }/jboss-5.1.0.GA.zip")}
end

execute 'extract_jboss_zipfile' do
  command "unzip jboss-5.1.0.GA.zip -d #{ node['jboss']['install_path'] }"
  cwd node['jboss']['tmp_dir']
  not_if { File.directory?("#{ node['jboss']['jboss_home'] }") }
end

remote_file "#{ node['jboss']['tmp_dir'] }/testweb.zip" do
  source node['jboss']['app_url']
  owner node['jboss']['jboss_user']
  group node['jboss']['jboss_group']
  mode '0755'
  action :create
  not_if { ::File.exists?("#{ node['jboss']['tmp_dir'] }/testweb.zip")}
end

execute 'extract_testweb_zipfile' do
  command "unzip testweb.zip -d #{ node['jboss']['deploy_path'] }"
  cwd node['jboss']['tmp_dir']
  not_if { File.directory?( "#{ node['jboss']['deploy_path']}/testweb" ) }
end


template "#{ node['jboss']['jboss_home'] }/bin/run.sh" do
  source "run_sh.erb"
  owner node['jboss']['jboss_user']
  group node['jboss']['jboss_group']
  mode '0755'
end

template "/etc/init.d/jboss" do
  source "jboss_init_il.erb"
  owner 'root'
  group 'root'
  mode '0755'
  variables ({
     :jboss_user => node['jboss']['jboss_user'],
     :jboss_home => node['jboss']['jboss_home'],
     :jboss_ip => node['jboss']['jboss_ip']
  })
  not_if { File.exist?('/etc/init.d/jboss' )}
end

directory node['jboss']['jboss_log'] do
  owner 'jboss'
  group 'jboss'
  mode '0755'
  action :create
  not_if { File.directory?( "#{ node['jboss']['jboss_log'] }" ) }
end

execute 'jboss folder ownership' do
  command "chown -R #{ node['jboss']['jboss_user'] }:#{ node['jboss']['jboss_group'] } #{ node['jboss']['jboss_home'] }"
end


service 'jboss' do
  init_command "/etc/init.d/jboss"
  supports :restart => true, :status => true, :stop => true
  action [ :enable, :start ]
end
