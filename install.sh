#!/bin/bash

if [ $EUID -ne 0 ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# check whether installation is already executed
if [ -e /root/.installed ]; then
    echo "The install script has already been run on this machine!" >&2
    exit 1
fi

echo "Updating package repositories..." >&2
apt-get update > /dev/null

echo "Updating software..."
apt-get upgrade -y > /dev/null

echo "Installing required software..." >&2
wget -q -O- https://cwlab.github.com/install/packages | xargs apt-get install -y

# Create a temporary directory
mkdir /tmp/cwlab
cd /tmp/cwlab

# Get the configuration files
git clone git://github.com/cwlab/install.git

# Start copying files
echo "Copying Skeleton files..." >&2
cp -R install/etc/skel /etc/

# Get the new .bashrc file
cp install/root/.bashrc /root
. /root/.bashrc

# Leave a trace
touch /root/.installed
