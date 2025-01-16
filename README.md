# RHCE
Preparing for RHCE exam

## Preparing practice environement
I am using VirtualBox and Vagrant to set up practice environement. This means that having Vagrant and Virtualbox installed is a prerequisite. Then you can issue *vagrant up* from the project root. It creates 1 manager node and 3 client nodes
All nodes will
* have 2 NIC-s, one NAT, for internet access and one host-only, having addresses from 192.168.95.0/24 network
* have a freshly created "ansible" user geared with ssh keys (same for all host), enabled to use sudo
* ssh password login enabled
* an **ansible_local** provisioning is used in this config, **ansible** software is by default installed to every node

Manager host will
* have ansible packages installed
* host project directoy mounted as synced folder to /vagrant dir - to share scripts and other files if needed
* host project directory mountes again to /ansiblescripts in the name of ansible user and withount word write rights. Also the **rhce_scripts** directory is linket into the homedir of ansible user. This is needed because Ansible will not accept an *ansible.cfg* file from a world-writeable directory, and there are practice tasks where you have to use such config.
* have a cloned copy ot Ansible documentation which is accessible on http://127.0.0.1:8080/latest/ - most probably the same way you can access docs during the exam
* a basic **.ansible.cfg** is put to the **ansible** user's home directory.

## Status
The current config is able to spin up a learning environement, also is able to destroy/reload or redo provisioning in an idempotent manner.
Even though I am sure that it should be written to be more consistent and more automatic. 
For example the **hosts** file provisioned to the VM-s should be automatically generated from the host-only IP addresses during **up** operation. Also the number of clients should be configurable.
As far as I know, on the real exam you will have exactly two VM-s, thus it does not really matter.

## Files structure
* README.md - this file
* Vagrantfile - the Vagrant config to spin up VM-s. Has many options to customize, see comments in the file.
* provision - host setup Ansible scripts for the clients and the manager node and ssh keys for ansible user
* rhce_scripts - Ansible scripts and projects used along the learning path

## Limitations
In the Vagrantfile you can specify which Vagrant box you plan to use. Even though the software installation part for the manager node is only prepared to do it on RedHat family, which makes sense, as the RHCE exam is done on RedHat. The difference between RedHat and Debian favors is the name of the webserver package and the way it is configured and also the use of SELinux and AppArmor. This would have been done in a distro-independent way, probably via Ansible roles.
