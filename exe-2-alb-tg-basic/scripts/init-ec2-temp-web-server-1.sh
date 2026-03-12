#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo “Connection established with $(hostname -f). Identified as Instance 1 of 2” >/var/www/html/index.html
