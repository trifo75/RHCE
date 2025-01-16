# -*- mode: ruby -*-
# vi: set ft=ruby :

# Set name prefix Virtualbox VM
# so itt will create names like   kubecluster-master1
vm_name_prefix = "rhce_examprep"


# the domain part of the FQDN to be set
domain = "inside.local"

# The box name to be used - this should be something from RedHat family
# because the customization of the manager node (apache install and config)
# is not prepared for anything else
# also RHCE exam is on RedHat, so it makes sense to use that
box = "generic/rocky9"
boxversion = "4.3.12"

# VM definitions. Neys:
#   * hostname
#   * ip        the ip address for the 2nd (host-only) adapter. The first is NAT adapter
#   * vcpus     num of CPUs (VirtualBox parameter)
#   * mem       amount of memory in MB (VirtualBox parameter)
#   * add_disk  list of additional disk sizes to be created. OPTIONAL
#               "add_disk" => [ "1GB", "5GB" ]   will create disk2 in 1GB size and disk3 in 5GB size. (VBox device names)

  vm_defs = [
    { "hostname" => "manager",    "ip" => "192.168.95.110", "vcpus" => 2, "mem" => 1024 },
    { "hostname" => "client1",    "ip" => "192.168.95.121", "vcpus" => 1, "mem" => 1024, "add_disk" => [ "5GB" ] },
    { "hostname" => "client2",    "ip" => "192.168.95.131", "vcpus" => 1, "mem" => 1024, "add_disk" => [ "5GB" ] },
    { "hostname" => "client3",    "ip" => "192.168.95.132", "vcpus" => 1, "mem" => 1024 },
  ]

# create entries to populate /etc/hosts
# hosts_content variable will hold the full content of /etc/hosts
hosts_content = "127.0.0.1 localhost\n::1       localhost\n"
vm_defs.each do |vm_def|
    hosts_content += "#{vm_def['ip']} #{vm_def['hostname']} #{vm_def['hostname']}.#{domain}\n"
end

# create entries to put in ansible inventory fo rthe controller node
# first entry skipped
inventory_content = "[mygroup]\n"
vm_defs.each do |vm_def|
    inventory_content += "#{vm_def["hostname"]}\n"
end




Vagrant.configure("2") do |config|
  config.vm.box = box
  config.vm.box_version = boxversion
  vm_defs.each do |vm_def|
    config.vm.define "#{vm_def["hostname"]}" do |machine|
      machine.vm.box      = box
      machine.vm.hostname = vm_def["hostname"]
      machine.vm.network "private_network", ip: vm_def["ip"]
      machine.vm.synced_folder ".", "/vagrant", diabled: false
      machine.vm.provider "virtualbox" do |vb_provider|
        vb_provider.name   = "#{vm_name_prefix}-#{vm_def["hostname"]}"
        vb_provider.memory = vm_def["mem"] 
        vb_provider.cpus   = vm_def["vcpus"] 
      end # provider

      #create additional disks if "add_disk" key exists on the vm definition
      if vm_def.has_key?("add_disk") && vm_def['add_disk'].respond_to?('each')
          vm_def['add_disk'].each.with_index(2) do |size,index|
             machine.vm.disk :disk, name: "#{vm_name_prefix}_#{vm_def["hostname"]}_disk#{index}",  size: "#{size}" 
          end
      end


      # populate /etc/hosts file using the content created in the beginning
      machine.vm.provision "shell", name: "Create /etc/hosts file", inline: "sudo echo '#{hosts_content}' > /etc/hosts"


      ####################################
      # additional host customization goes here

      # put ansible inventory to host named "controller"
      if vm_def["hostname"] == "controller"
        machine.vm.provision "shell", name: "Create /etc/ansible/hosts", inline: "[ ! -d /etc/ansible ] && sudo mkdir /etc/ansible ; sudo echo '#{inventory_content}' > /etc/ansible/hosts"
      end

      # Do the host customization using ansible_local provisioning
      machine.vm.provision "ansible_local", playbook: "provision/provision_all_hosts.yml"

      # if you want to do something only on a specific guest
      # here we run extra ansible customization and enable port forwarding for the manager host
      # so that it will be available on port 8080
      if vm_def["hostname"] == "manager"
        machine.vm.provision "ansible_local", playbook: "provision/provision_manager.yml"
        machine.vm.network "forwarded_port", guest: 80, host: 8080
        manager.vm.provision "file", source: "provision/ansible.cfg", destination: "~ansible/.ansible.cfg"

      end



    end # vm define
  end # vm_defs loop


end # config









































#   Vagrant.configure("2") do |config|
#   
#     config.vm.define "manager" do |manager|
#      manager.vm.box = "generic/rocky9"
#      manager.vm.hostname = "manager.local"
#      manager.vm.network "private_network", ip: "192.168.95.110"
#   #   manager.vm.synced_folder ".", "/vagrant", disabled: false
#      manager.vm.network "forwarded_port", guest: 80, host: 8080
#      manager.vm.provider "virtualbox" do |v|
#        v.name = "RHCE_manager_synctest"
#        v.memory = 1024
#        v.cpus = 2
#      end # end provider
#   
#      #install Ansible
#      manager.vm.provision "shell", inline: "sudo dnf makecache ; sudo dnf install -y ansible ; echo Yess, Ansible is installed!"
#   
#      # push provisioning data to VM
#      manager.vm.provision "file", source: "provision", destination: "/tmp/provision"
#   
#      #execute provision script
#      # - create ansible user
#      # - populate hosts file
#      # - enable sshd password auth
#      manager.vm.provision "shell", inline: "sudo bash /tmp/provision/provision.sh"
#   
#   #   ### populate known_hosts file in a questionable manner - only on manager node
#   #   manager.vm.provision "shell", inline: <<-SHELL
#   #     su -c "ssh -o StrictHostKeyChecking=no client1 true" ansible
#   #     su -c "ssh -o StrictHostKeyChecking=no client2 true" ansible
#   #     su -c "ssh -o StrictHostKeyChecking=no client3 true" ansible
#   #SHELL
#   
#   
#      ### install httpd and get Ansible offline docs - as usable on the exam 
#      manager.vm.provision "shell", inline: <<-SHELL
#        # install git (for docs content) and apache
#        sudo dnf -y install git httpd
#   
#        # enable http service in the firewall permanently - then reload config
#        sudo firewall-cmd --add-service=http --permanent
#        sudo firewall-cmd --reload
#   
#        # enable and start httpd daemon
#        sudo systemctl enable --now  httpd
#   
#        # empty out /var/www/html - make room for git clone
#        # then get contents and apply SELinux policy to be able to served
#        sudo rm -rf /var/www/html/*
#        sudo git clone  "https://github.com/aggressiveHiker/rhce9-docs-ansible" /var/www/html/
#        sudo restorecon -vR /var/www/html
#   
#   SHELL
#      manager.vm.synced_folder "ansible_scripts", "/ansible_scripts", disabled: false, create: true, owner: "ansible", group: "ansible"
#   
#      manager.vm.disk :disk, name: "disk2", size: "2GB"
#      manager.vm.disk :disk, name: "disk3", size: "3GB"
#   
#     end # end vm.define
#   #
#   #  (1..3).each do |i|
#   #    config.vm.define "client#{i}" do |client|
#   #      client.vm.box = "generic/rocky9"
#   #      client.vm.hostname = "client#{i}.local"
#   #      client.vm.network "private_network", ip: "192.168.95.11#{i}"
#   #      #client.vm.synced_folder ".", "/vagrant", disabled: true
#   #
#   #      client.vm.provider "virtualbox" do |v|
#   #        # Customize the amount of memory on the VM:
#   #        v.name   = "RHCE client #{i}"
#   #        v.memory = "512"
#   #        v.cpus   = "1"
#   #      end # end provider
#   #
#   #      # push provisioning data to VM
#   #      client.vm.provision "file", source: "provision", destination: "/tmp/provision"
#   #
#   #      #execute provision script
#   #      # - create ansible user
#   #      # - populate hosts file
#   #      # - enable sshd password auth
#   #      client.vm.provision "shell", inline: "sudo bash /tmp/provision/provision.sh"
#   #
#   #
#   #    end # end vm.define
#   #  end # end loop i
#   
#   end # end config


