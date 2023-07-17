#!/bin/bash
sudo yum update -y
sudo yum install -y httpd  
sudo systemctl start httpd
sudo systemctl enable httpd 

echo "<html><body><h1>Let's Go Green Team</h1><p>We Got this</body><html>" > /var/www/html/index.html