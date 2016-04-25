#
# Cookbook Name:: tomcat
# Recipe:: install
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

extract_path = '/opt'

user node['tomcat']['tomcat_user'] do
    comment 'tomcat user'
    home "#{ extract_path }/#{ node['tomcat']['app_name'] }"
    shell '/bin/bash'
    password '$1$UI5ZNV67$uFLsTBdORqco0Ho2pSlWP/'
  end

group node['tomcat']['tomcat_group'] do
    action :create
  end

src_filename = "#{ node['tomcat']['app_name'] }.tar.gz"

remote_file "/tmp/#{ src_filename }" do
    source "http://ftp.byfly.by/pub/apache.org/tomcat/tomcat-7/#{ node['tomcat']['app_version'] }/bin/#{ src_filename }"
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

bash 'extract_tomcat_tarball' do
    cwd "/tmp"
    code <<-EOH
    tar xzf #{ src_filename } -C #{extract_path}
    EOH
    action :nothing
    #subscribes on previous remote_file resousce
    subscribes :run, "remote_file[/tmp/#{ src_filename }]", :immediately    
  end

app_name = "#{ node['tomcat']['app_name'] }"

directory "#{ extract_path }/#{ app_name }" do
    owner node['tomcat']['tomcat_user']
    group node['tomcat']['tomcat_group']
    mode '0755'
  end


bash 'change owner of tomcat directory recursively' do
    cwd "/tmp"
    code <<-EOH
    chown -R #{ node['tomcat']['tomcat_user'] }:#{ node['tomcat']['tomcat_group'] } #{ extract_path }/#{ node['tomcat']['app_name'] }
    EOH
    action :nothing
    #subscribes on previous directory resousce
    subscribes :run, "directory[#{ extract_path }/#{ app_name }]", :immediately
  end

cookbook_file '/etc/init.d/tomcat' do
    source 'tomcat_init'
    owner 'root'
    group 'root'
    mode '0755'
    not_if { ::File.exists?('/etc/init.d/tomcat')}
  end

template "#{ extract_path }/#{ app_name }/conf/server.xml" do
    source "server_xml.erb"
    owner node['tomcat']['tomcat_user']
    group node['tomcat']['tomcat_group']
    mode '0600'
    variables ({
       :tomcat_http_port => node['tomcat']['tomcat_http_port']       
       })
  end

# cookbook_file "#{ extract_path }/#{ app_name }/.bashrc" do
#     source 'tomcat_bashrc'
#     owner 'root'
#     group 'root'
#     mode '0755'
#     not_if { ::File.exists?("#{ extract_path }/#{ app_name }/.bashrc")}
#   end

tomcat_resource 'tomcat status' do
    action :status
    provider "tomcat_provider"
  end

tomcat_resource 'tomcat start' do
    action :nothing
    provider "tomcat_provider"
    subscribes :start, "tomcat_resource[tomcat status]", :immediately
  end

tomcat_resource 'tomcat enable' do
    action :enable
    provider "tomcat_provider"    
  end