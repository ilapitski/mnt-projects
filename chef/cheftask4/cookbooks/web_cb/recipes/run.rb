#
# Cookbook Name:: web_cb
# Recipe:: run
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

if node.role?('nginx_role')
   include_recipe 'nginx_cb::nginx_run'
elsif node.role?('apache_role')
   include_recipe 'apache_cb::apache_run'
else
   execute 'bash_command' do
      command "echo 'nothing to do.. bye'"
   end
end
