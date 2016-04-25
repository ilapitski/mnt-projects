action :install do
  package 'nginx'  
end

action :start do
  service 'nginx' do
    action :start
  end  
end

action :stop do
  service 'nginx' do
    action :stop
  end  
end

action :restart do
  service 'nginx' do
    action :restart
  end  
end

action :enable do
  service 'nginx' do
    action :enable
  end  
end

action :setup do
  template "/usr/share/nginx/html/index.html" do
    source "index.erb"
    variables({
      :hello => new_resource.name,
      :type => new_resource.type_of_server
    })
  end
end

action :remove do
  package 'nginx' do
    action :delete
  end
end
