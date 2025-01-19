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


      # repair device UUID-s to get rid of warning messages like
      #    Devices file sys_wwid t10.ATA_VBOX_HARDDISK_VBa64d3d26-8dd3a5f6 PVID bbyAlJIN9bj4rcDjcYVVqMBz72umwe05 last seen on /dev/sda2 not found.
      # we look for missing UUID-s, delete them and add devices back
      # the regex is looking for the word after "PVID" in the abowe error message
      machine.vm.provision "shell", name: "Create /etc/hosts file", inline: <<-SHELL
        # when there is no "not found" in the output of lvmdevices, we simply exit
        lvmdevices --check 2>&1 | grep -q "not found" || exit 0
        # collect problematic UUIDs and delete them
        lvmdevices --check 2>&1 | sed -E 's/^.*PVID (\S+).*$/\1/g' | xargs -n1 lvmdevices -y --delpvid
        # re-add missing dev to /etc/lvm/devices/system.devices
        vgimportdevices -a
SHELL

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

      end



    end # vm define
  end # vm_defs loop


end # config

