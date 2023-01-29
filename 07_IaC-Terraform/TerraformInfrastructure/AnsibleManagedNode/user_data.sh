#!/bin/bash

#---User data for terraform file including Ansible instalation for Ubuntu 22.04---#

# Installing python3 via update and upgrade command
sudo apt update
sudo apt -y upgrade

# checking python version
python3 --version > /home/ubuntu/python3_version.txt

# Installing pip3
sudo apt install -y python3-pip

#checking pip version
python3 -m pip -V > /home/ubuntu/pip3_version.txt


# Installing Ansible on Ubuntu

# 1. Use pip in your selected Python environment to install the Ansible package
# of your choice for the current user:

sudo -u ubuntu python3 -m pip install --user ansible-core==2.14.1


# Add a folder /home/ubuntu/.local/bin to $PATH variable (system wide):
sudo cat << EOF >> /etc/bash.bashrc
if [ -d "/home/ubuntu/.local/bin" ] ; then
   PATH="/home/ubuntu/.local/bin:$(echo '$PATH')"
fi
EOF

# Add a folder /home/ubuntu/.local/bin to $PATH variable (for current user):
sudo cat << EOF >> /home/ubuntu/.bashrc
if [ -d "/home/ubuntu/.local/bin" ] ; then
  PATH="/home/ubuntu/.local/bin:$(echo '$PATH')"
fi
EOF

# test that Ansible is installed correctly by checking the version:
sudo exec bash
exec bash
sudo -u ubuntu ansible --version > /home/ubuntu/ansible_version.txt


#----------------------------------------------------------------------------#
# 2. Alternative way to install Ansible:
# To configure the PPA on your system and install Ansible run these commands:
# sudo apt update
# sudo apt install -y software-properties-common
# sudo add-apt-repository --yes --update ppa:ansible/ansible
# sudo apt install -y ansible
#----------------------------------------------------------------------------#