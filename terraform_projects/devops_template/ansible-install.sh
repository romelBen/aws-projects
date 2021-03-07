#!/bin/bash

# Full update of RHEL 8 distro
sudo su -
yum update -y

# Add third party repository named EPEL
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

# Installation of Ansible
yum install ansible

# Create a new user and password for the user
useradd ansadmin
passwd ansadmin
