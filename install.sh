#!/bin/bash

if [ $EUID -e 0 ]; then
    echo "This script should not be run as root" 1>&2
    exit 1
fi

echo "Updating package repositories..." >&2
sudo apt-get update > /dev/null

echo "Updating software..."
sudo apt-get upgrade -y > /dev/null

echo "Installing required software..." >&2
wget -q -O- https://cwlab.github.com/install/packages | xargs sudo apt-get install -y

# Create a temporary directory
mkdir /tmp/cwlab
cd /tmp/cwlab

# Get the configuration files
git clone git://github.com/cwlab/install.git

# Start copying files
echo "Copying Skeleton files..." >&2
sudo cp -f install/etc/skel/.bashrc /etc/skel

# Install the new .bashrc file
cp /etc/skel/.bashrc ~
source  ~/.bashrc

# End elevated privileges
sudo -K
