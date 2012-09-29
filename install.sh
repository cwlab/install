#!/bin/bash

USER=${1:-root}

if [[ $USER = 'root' ]]; then
	if [ $EUID -eq 0 ]; then
		echo "Don't run this script as root, it will ask for root permissions when needed." >&2
		exit 1
	fi
	sudo $0 $(whoami) || exit $$
	
	. ~/.bashrc
	exit 0
else
	if [ $EUID -eq 0 ]; then
		echo -n ''
	else
		echo "Run this script without params" >&2
		exit 1
	fi
fi

# check whether installation is already executed
if [ -e /root/.installed ]; then
    echo "The install script has already been run on this machine!" >&2
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
git clone -q git://github.com/cwlab/install.git

# Start copying files
echo "Copying Skeleton files..." >&2
sudo cp -f install/etc/skel/.bashrc /etc/skel

# Get the new /root/.bashrc file
cat install/root/.bashrc > /root/.bashrc
[ -x /root/.bashrc ] || chmod +x /root/.bashrc

# Get the new .bashrc file in the homedir of our current user
su $USER -c 'cat /etc/skel/.bashrc > ~/.bashrc'

# End elevated privileges
sudo -K
