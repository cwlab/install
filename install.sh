#!/bin/sh

if [ `whoami` != "root" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# check whether installation is already executed
if [ -e ~/.installed ]; then
    echo "The install script has already been run on this machine!"
    exit 1
fi

echo "Updating package repositories..."
apt-get update > /dev/null

echo "Updating software..."
apt-get dist-upgrade -y > /dev/null

echo "Installing required software..."
apt-get install -y git htop man

# Create a temporary directory
mkdir /tmp/cwlab
cd /tmp/cwlab

# Get the configuration files
git clone git://github.com/cwlab/install.git

# Start copying files
echo "Copying Skeleton files..."
cp -R install/etc/skel/ /etc

# Leave a trace
touch ~/.installed
