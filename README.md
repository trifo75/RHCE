# RHCE
Preparing for RHCE exam

## Preparing practice environement
I am using VirtualBox and Vagrant to set up practice environement. This means that having Vagrant and Virtualbox installed is a prerequisite. Then you can issue *vagrant up* from the project root. It creates 1 manager node and 3 client nodes
All nodes will
* have 2 NIC-s, one NAT, for internet access and one host-only, having addresses from 192.168.95.0/24 network
* have a freshly created "ansible" user geared with ssh keys (same for all host), enabled to use sudo
* ssh password login enabled

Manager host will
* have ansible packages installed
* host project directoy mounted as synced folder to /vagrant dir - to share scripts and other files if needed
* have a cloned copy ot Ansible documentation which is accessible on http://127.0.0.1:8080/latest/ - most probably the same way you can access docs during the exam 

## Status
The current config is able to spin up a learning environement, also is able to destroy/reload or redo provisioning in an idempotent manner.
Even though I am sure that it should be written to be more consistent and more automatic. 
For example the **hosts** file provisioned to the VM-s should be automatically generated from the host-only IP addresses during **up** operation. Also the number of clients should be configurable.
As far as I know, on the real exam you will have exactly two VM-s, thus it does not really matter.

## Files structure
* README.md - this file
* Vagrantfile - the Vagrant config to spin up VM-s
* provision - host setup script and ssh keys for ansible user
* ansible - Ansible scripts and projects used along the learning path

