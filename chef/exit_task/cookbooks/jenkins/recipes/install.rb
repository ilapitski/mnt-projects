#
# Cookbook Name:: jenkins
# Recipe:: install
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

extract_path = '/opt'

user node['jenkins']['jenkins_user'] do
    comment 'jenkins user'
    home "/home/#{ node['jenkins']['jenkins_user'] }"
    shell '/bin/bash'
    password '$1$UU4Emxdw$FLnVUrfHBvEs8jIvLvEmI.'
  end

group node['jenkins']['jenkins_group'] do
    action :create
  end

cookbook_file '/etc/sudoers.d/jenkins' do
    source 'jenkins_sudoers_d_file'
    owner 'root'
    group 'root'
    mode '0440'    
  end

template "/home/#{node['jenkins']['jenkins_user']}/.bashrc" do
	source "jenkins_bashrc.erb"
    owner node['jenkins']['jenkins_user']
    group node['jenkins']['jenkins_group']
    mode '0644'
    variables ({
    	:m2_home => node['jenkins']['jenkins_m2_home'],
    	:m2 => node['jenkins']['jenkins_m2'],
    	:maven_opts => node['jenkins']['maven_opts'],
    	:path => node['jenkins']['jenkins_path']
    })
  end

package 'git' do
    action :install
  end

remote_file '/etc/yum.repos.d/jenkins.repo' do
    source 'http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo'
    owner 'root'
    group 'root'
    mode '0644'
    action :create
    not_if { File.exist?('/etc/yum.repos.d/jenkins.repo' )}
  end

template "/etc/yum.repos.d/jenkins.repo" do
	source "jenkins_repo.erb"
    owner 'root'
    group 'root'
    mode '0644'
    variables ({
    	:gpg_key_url => node['jenkins']['jenkins_key_url']
    })
    action :nothing
    subscribes :create, "remote_file[/etc/yum.repos.d/jenkins.repo]", :immediately
  end

package 'jenkins' do
    action :install
  end

template "/etc/sysconfig/jenkins" do
	source "jenkins_sysconfig.erb"
    owner 'root'
    group 'root'
    mode '0600'
    variables ({
    	:jenkins_port => node['jenkins']['jenkins_port'],
    	:jenkins_bind_address => node['jenkins']['jenkins_bind_address'],
    	:jenkins_ajp_port => node['jenkins']['jenkins_ajp_port'],
    	:jenkins_prefix => node['jenkins']['jenkins_prefix']
    })
    #action :nothing
    #notifies :restart, "service[jenkins]", :delayed
  end

maven_tar = "#{ node['jenkins']['jenkins_maven'] }-bin.tar.gz"

remote_file "/tmp/#{ maven_tar }" do
    source "http://ftp.byfly.by/pub/apache.org/maven/maven-3/3.3.9/binaries/#{ maven_tar }"
    owner node['jenkins']['jenkins_user']
    group node['jenkins']['jenkins_group']
    mode '0755'
    action :create
  end

bash 'extract_maven_tarball' do
    cwd "/tmp"
    code <<-EOH
    tar xzf #{ maven_tar } -C #{ extract_path }
    EOH
    action :nothing
    #subscribes on previous remote_file resousce
    subscribes :run, "remote_file[/tmp/#{ maven_tar }]", :immediately    
  end

maven_name = "#{ node['jenkins']['jenkins_maven'] }"

directory "#{ extract_path }/#{ maven_name }" do
    owner node['jenkins']['jenkins_user']
    group node['jenkins']['jenkins_group']
    mode '0755'
  end  

bash 'change owner of maven directory recursively' do
    cwd "/tmp"
    code <<-EOH
    chown -R #{node['jenkins']['jenkins_user']}:#{node['jenkins']['jenkins_user']} #{ extract_path }/#{ maven_name }
    EOH
    action :nothing
    #subscribes on previous remote_file resousce
    subscribes :run, "directory[#{extract_path}/#{maven_name}]", :immediately
  end

remote_directory "/var/lib/jenkins" do
	source 'jenkins'
	action :create_if_missing
	notifies :run, 'bash[chown -R jenkins dir]', :immediately
  end

jenkins_name = "#{ node['jenkins']['jenkins_user'] }"

bash 'chown -R jenkins dir' do
    cwd '/tmp'
    code <<-EOH
    chown -R #{node['jenkins']['jenkins_user']}:#{node['jenkins']['jenkins_user']} /var/lib/#{node['jenkins']['jenkins_user']}
    EOH
    action :nothing
  end

service 'jenkins' do
    action :start
  end
