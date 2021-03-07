#!/bin/sh

# This is to install Apache and create a file for testing
sudo yum update
sudo yum install -y httpd
sudo chkconfig httpd on
sudo service httpd start
echo "<h1>Hello this is Romel</h1>" | sudo tee /var/www/html/index.html