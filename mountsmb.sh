#!/usr/bin/env bash

read -p "Enter user to mount samba share as : " username
read -p "Enter samba share address (ex: 192.168.0.119) : " address
read -p "Enter samba share name (ex: share) : " share

echo "The share will be mounted in /mnt"
echo "Mounting $address/$share as $username..."

sudo mount -t cifs -o username=$username "//$address/$share" /mnt/

if [ $? -eq 0 ]
then
    echo "$share is mounted!"
else
    echo "Mounting failed..."
fi