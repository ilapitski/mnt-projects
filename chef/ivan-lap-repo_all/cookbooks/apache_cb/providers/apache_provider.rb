action :install do
  package 'httpd'  
end

action :start do
  service 'httpd' do
    action :start
  end  
end

action :stop do
  service 'httpd' do
    action :stop
  end  
end

action :restart do
  service 'httpd' do
    action :restart
  end  
end

action :enable do
  service 'httpd' do
    action :enable
  end  
end

action :setup do
  template "/var/www/error/noindex.html" do
    source "noindex.erb"
    variables({
      :hello => new_resource.name,
      :type => new_resource.type_of_server
    })
  end
end

action :remove do
  package 'httpd' do
    action :delete
  end
end
