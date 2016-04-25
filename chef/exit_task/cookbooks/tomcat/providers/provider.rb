action :status do
    
    tomcat = 'tomcat'   
    command = Mixlib::ShellOut.new("pgrep -f #{ tomcat }")
    command.run_command
    
    #status is string, that is returned by bash command
    status = command.stdout
    
    if status.nil? || status.empty?
      new_resource.updated_by_last_action(true)
    else
      new_resource.updated_by_last_action(false)
    end
  end

action :start do
    #init_command = "/etc/init.d/tomcat"
    init_command = "/etc/init.d/#{ @new_resource.service_name }"
    start = Mixlib::ShellOut.new("#{init_command} start")
    start.run_command
  end

action :stop do
    #init_command = "/etc/init.d/tomcat"
    init_command = "/etc/init.d/#{ @new_resource.service_name }"
    Mixlib::ShellOut.new("#{init_command} stop")
    stop.run_command
  end

action :restart do
    #init_command = "/etc/init.d/tomcat"
    init_command = "/etc/init.d/#{ @new_resource.service_name }"
    start = Mixlib::ShellOut.new("#{init_command} stop")
    stop = Mixlib::ShellOut.new("#{init_command} start")
    stop.run_command
    start.run_command
  end

action :enable do
    service 'tomcat' do
      tomcat = 'tomcat'
      init_command = "/etc/init.d/#{ tomcat }"
      supports :start => true, :stop => true, :status => true, :restart => true
      action :enable
    end
  end
