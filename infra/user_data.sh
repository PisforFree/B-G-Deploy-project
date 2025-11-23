#!/bin/bash
set -xe

# Log to a file so we can debug later if needed
exec > /var/log/user-data.log 2>&1

# Update packages
yum update -y

# Install Docker (Amazon Linux 2)
amazon-linux-extras install docker -y || yum install -y docker

# Enable and start Docker service
systemctl enable docker
systemctl start docker

# Allow ec2-user to use Docker without sudo
usermod -aG docker ec2-user

echo "User data completed: Docker installed and running." >> /var/log/user-data.log
