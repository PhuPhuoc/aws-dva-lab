#!/bin/bash
yum update -y
yum install -y httpd.x86_64

systemctl start httpd.service
systemctl enable httpd.service

echo "Connection established with $(hostname -f). Instance launched by ASG" >/var/www/html/index.html

# add ssh public key
mkdir -p /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh

echo "ssh-ed25519 AAAAC3Nzaxxxx user@mail.com" >>/home/ec2-user/.ssh/authorized_keys

chmod 600 /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
