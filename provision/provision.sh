

### Enable SSH password auth - it is disabled in the box by default - WHY?

# Editing sshd config file
# the "PasswordAuthentication no" directive appears 3 tomes in the default config - WHY?
sudo sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# restarting daemon with updated config
sudo systemctl reload sshd


### create "ansible" user
# remove any remains of ansible user if exists
id ansible && userdel -r ansible
# the recreate user
useradd -u 5000 -c "Ansible technical user" ansible
# populate .ssh with the pre-added keys
mkdir -m 700 ~ansible/.ssh
cp /tmp/provision/id_rsa* ~ansible/.ssh/
cp /tmp/provision/authorized_keys ~ansible/.ssh/
chmod 600 ~ansible/.ssh/id_rsa
chmod 644 ~ansible/.ssh/id_rsa.pub
chmod 600 ~ansible/.ssh/authorized_keys
chown -R ansible.ansible ~ansible/.ssh

### Enable sudo for ansible user
cat > /etc/sudoers.d/ansible << EOF
# Enable ansible user to be root without password
Defaults:vagrant !fqdn
Defaults:vagrant !requiretty
ansible ALL=(ALL) NOPASSWD: ALL

EOF


### populate hosts file
# remove entries from 192.168.95.x network
sed -i '/^.*192\.168\.95\..*$/d' /etc/hosts
# add entries (a little more than needed)
cat >> /etc/hosts << EOF
192.168.95.110   manager
192.168.95.111   client1
192.168.95.112   client2
192.168.95.113   client3
192.168.95.114   client4
192.168.95.115   client5
192.168.95.116   client6
EOF


#### populate known_hosts file in a questionable manner
#su -c "ssh -o StrictHostKeyChecking=no client1 true" ansible
#su -c "ssh -o StrictHostKeyChecking=no client2 true" ansible
#su -c "ssh -o StrictHostKeyChecking=no client3 true" ansible


