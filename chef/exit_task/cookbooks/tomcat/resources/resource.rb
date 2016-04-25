#
# Cookbook Name:: tomcat
# Provider:: tomresource.rb
#

actions :start, :stop, :status, :enable

attribute :service_name, :kind_of => String, :name_attribute => true