# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|

$script = <<SCRIPT
echo Provisioning...
echo "Chef..."
sudo rpm -Uvh /vagrant/chefdk-0.12.0-1.el6.x86_64.rpm
cp -r /vagrant/.chef /home/vagrant/
cp -r /vagrant/chef_cookbooks/ /home/vagrant/
cp /vagrant/jboss-5.1.0.GA.zip /tmp/
chown -R vagrant:vagrant /home/vagrant/.chef/
chown -R vagrant:vagrant /home/vagrant/chef_cookbooks/
chef-solo -c /home/vagrant/.chef/solo.rb | tee -a task2_solo.log
chef-solo -c /home/vagrant/.chef/solo.rb | tee -a task2_solo_run_again.log
SCRIPT

  config.vm.provision "shell", inline:$script  # provisioning

  config.vm.box = "sbeliakou/centos-6.7-x86_64"
  config.vm.network "private_network", ip: "192.168.33.20"
  #config.vm.network "forwarded_port", guest: 80, host: 8180
  config.vm.network "forwarded_port", guest: 8080, host: 8090
  config.vm.hostname = "chef02"
  
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.name = "taskchef02"
  end

end
