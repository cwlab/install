#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit -1
fi

SOURCE=`dirname $0`

echo "Updating package repositories..."
apt-get update > /dev/null

echo "Updating software..."
apt-get dist-upgrade -y > /dev/null

echo "Installing required software..."
apt-get install -y git 

echo "Copying Skeleton files..."
cp -R $SOURCE"/etc/skel" /etc
