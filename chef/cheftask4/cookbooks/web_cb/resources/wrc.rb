#
# Cookbook Name:: web_cb
# Provider:: depends_on_role
#

actions :install, :start, :stop, :restart, :enable, :setup, :remove

attribute :name, :kind_of => String, :name_attribute => true
attribute :type_of_server, :kind_of => String, default: "Web server type?"
