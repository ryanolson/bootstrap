#!/usr/bin/env bash

# Ensure running as regular user
if [ $(id -u) -eq 0 ] ; then
    echo "Please run as a regular user"
    exit 1
fi

# Install newer version of Ansible
sudo apt-get -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get -y install ansible

# Add nvidia-docker role from Ansible Galaxy
ansible-galaxy install ryanolson.nvidia-docker

# Write playbook
playbook=$(mktemp)
cat <<EOF > $f
- hosts: all
  roles:
    - role: 'ryanolson.nvidia-docker'
      become: true
  tasks:
    - name: docker | add user to docker group
      user: name=$USER groups=docker append=yes become=true
EOF

# Execute playbook
ansible-playbook -i "localhost," -c local $playbook

# cleanup
rm -f $playbook
exit
