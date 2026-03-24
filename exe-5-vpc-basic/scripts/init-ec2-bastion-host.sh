#!/bin/bash
yum update -y

# add ssh public key
mkdir -p /home/ec2-user/.ssh
chmod 700 /home/ec2-user/.ssh

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwPrw+E0w2eCwCr0S0TuN66amaLfH4zpwx3k190XbTA deb.phuoc.tran@terralogic.com" >>/home/ec2-user/.ssh/authorized_keys

chmod 600 /home/ec2-user/.ssh/authorized_keys
chown -R ec2-user:ec2-user /home/ec2-user/.ssh

# ghi private key
cat <<EOF >/home/ec2-user/.ssh/id_rsa
${private_key}
EOF

chmod 600 /home/ec2-user/.ssh/id_rsa
chown -R ec2-user:ec2-user /home/ec2-user/.ssh
