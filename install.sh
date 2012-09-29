#!/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" 1>&2
    exit -1
fi

# check whether installation is already executed
if [ -e /etc/cwlab/ ]; then
    echo "The CWLab install script has already been run on this machine!"
    exit 1
fi

echo "Updating package repositories..."
apt-get update > /dev/null

echo "Updating software..."
apt-get dist-upgrade -y > /dev/null

echo "Installing required software..."
apt-get install -y git

# Create a temporary directory
mkdir /tmp/cwlab && cd /tmp/cwlab

# Get the configuration files
git checkout https://github.com/cwlab/install.git install

# Start copying files
echo "Copying Skeleton files..."
cp -R "etc/skel" /etc
