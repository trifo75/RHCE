# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "manager" do |manager|
   manager.vm.box = "generic/rocky9"
   manager.vm.hostname = "manager.local"
   manager.vm.network "private_network", ip: "192.168.95.110"
   manager.vm.provider "virtualbox" do |v|
     v.name = "RHCE_manager"
     v.memory = 1024
     v.cpus = 2
   end # end provider

   #install Ansible
   manager.vm.provision "shell", inline: "sudo dnf makecache ; sudo dnf install -y ansible ; echo Yess, Ansible is installed!"

   # push provisioning data to VM
   manager.vm.provision "file", source: "provision", destination: "/tmp/provision"

   #execute provision script
   # - create ansible user
   # - populate hosts file
   # - enable sshd password auth
   manager.vm.provision "shell", inline: "sudo bash /tmp/provision/provision.sh"

   ### populate known_hosts file in a questionable manner - only on manager node
   manager.vm.provision "shell", inline: <<-SHELL
     su -c "ssh -o StrictHostKeyChecking=no client1 true" ansible
     su -c "ssh -o StrictHostKeyChecking=no client2 true" ansible
     su -c "ssh -o StrictHostKeyChecking=no client3 true" ansible
SHELL

  end # end vm.define

  (1..3).each do |i|
    config.vm.define "client#{i}" do |client|
      client.vm.box = "generic/rocky9"
      client.vm.hostname = "client#{i}.local"
      client.vm.network "private_network", ip: "192.168.95.11#{i}"
      #client.vm.synced_folder ".", "/vagrant", disabled: true

      client.vm.provider "virtualbox" do |v|
        # Customize the amount of memory on the VM:
        v.name   = "RHCE client #{i}"
        v.memory = "512"
        v.cpus   = "1"
      end # end provider

      # push provisioning data to VM
      client.vm.provision "file", source: "provision", destination: "/tmp/provision"

      #execute provision script
      # - create ansible user
      # - populate hosts file
      # - enable sshd password auth
      client.vm.provision "shell", inline: "sudo bash /tmp/provision/provision.sh"


    end # end vm.define
  end # end loop i

end # end config


