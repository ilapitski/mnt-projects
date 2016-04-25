# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "sbeliakou/centos-6.7-x86_64"
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.hostname = "chef0"
  
  config.vm.provider "virtualbox" do |vb|
    vb.name = "taskchef0"
  end

#  config.vm.provision "ansible" do |ansible|
#    ansible.playbook = 'provision2.yml'
#    ansible.verbose = 'vv'
#  end
end
