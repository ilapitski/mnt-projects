#
# Cookbook Name:: common
# Recipe:: prepare
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory '/tmp/install' do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end

file '/etc/yum.repos.d/NGINX.repo' do
    owner 'root'
    group 'root'
    mode '0644'
  end

package 'nginx' do
    action :install
  end
  
template "/etc/nginx/nginx.conf" do
    source "nginx_conf.erb"
    owner 'nginx'
    group 'nginx'
    mode '0755'
    variables ({
       :config_file_name => node['nginx']['config_file_name']       
    })
    notifies :reload, "service[nginx]", :delayed
    #not_if { File.exist?('/etc/nginx/conf.d/virtual.conf' )}
end
  
template "/etc/nginx/conf.d/virtual.conf" do
    source "virtual_conf.erb"
    owner 'nginx'
    group 'nginx'
    mode '0755'
    variables ({
       :nginx_http_port => node['nginx']['http_port'],
       :tomcat_http_port => node['tomcat']['http_port'],
       :jenkins_http_port => node['jenkins']['http_port'],
       :jenkins_listen_address => node['jenkins']['listen_address'],
    })
    notifies :reload, 'service[nginx]', :delayed
    #not_if { File.exist?('/etc/nginx/conf.d/virtual.conf' )}
  end

service 'nginx' do
    supports :status => true, :restart => true, :reload => true
    action [:enable, :start]
  end  
