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
 