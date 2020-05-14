#!/usr/bin/env bash

#Query the user about the share to mount
read -p "Enter user to mount samba share as : " username
read -p "Enter samba share address : " address
read -p "Enter samba share name : " share

echo "The share will be mounted in /mnt/"
echo "Mounting $address/$share as $username..."

#Mount the share on /mnt/
sudo mount -t cifs -o username=$username "//$address/$share" /mnt/

#Check if an error occured while mounting
if [ $? -eq 0 ]
then
    echo "$share is mounted!"
else
    echo "Mounting failed..."
fi