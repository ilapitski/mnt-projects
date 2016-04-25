#
# Cookbook Name:: apache_cb
# Recipe:: apache_run
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


# from web_cb use resource wrc
web_cb_wrc "install apache" do
action :install
# from apache_cb use apache_provider
provider "apache_cb_apache_provider"
end

web_cb_wrc "ws apache" do
type_of_server "modified with chef"
action :setup
provider "apache_cb_apache_provider"
end


web_cb_wrc "enable & start apache" do
action [:enable, :start]
provider "apache_cb_apache_provider"
end
