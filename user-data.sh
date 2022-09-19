#!/bin/sh
#
# EC2 instance Docker provision script.
#
# Copyright 2022, Marc S. Brooks (https://mbrooks.info)
# Licensed under the MIT license:
# http://www.opensource.org/licenses/mit-license.php
#
#  Notes:
#   - This script has been tested to work with RHEL & CentOS
#   - This script must be run as root

[ -d /root/.build ] && exit 0

# Install dependencies.
yum -y install https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
yum -y install git

amazon-linux-extras install docker

service docker start && chkconfig docker on

git clone --recurse-submodules https://github.com/nuxy/aws-ec2-opensimulator.git /root/.build

# Create 4GB swapfile (support t2.small)
dd if=/dev/zero of=/swapfile bs=128M count=32

if [ -f /swapfile ]; then
    chmod 600 /swapfile
    mkswap /swapfile
    swapon -s
    echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
fi

# Launch the grid server.
docker pull marcsbrooks/docker-opensimulator-server

docker run -d --network host --restart always marcsbrooks/docker-opensimulator-server:latest