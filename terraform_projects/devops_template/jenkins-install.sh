#!/bin/bash
sudo yum -y update

# Installation of Java JDK 8
echo "Install Java JDK 8"
sudo yum remove -y java
sudo yum install -y java-1.8.0-openjdk

# Installation of git
echo "Install git"
sudo yum -y git

# Insallation of Jenkins
echo "Install Jenkins"
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
sudo yum install -y jenkins
sudo usermod -a -G docker jenkins
sudo chkconfig jenkins on

# Start Jenkins
sudo service jenkins start