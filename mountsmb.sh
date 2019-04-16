#!/usr/bin/env bash

#Query the user about the share to mount
read -p "Enter user to mount samba share as : " username
read -p "Enter samba share address (ex: 192.168.0.119 or 192.168.0.170) : " address
read -p "Enter samba share name (ex: share) : " share

echo "The share will be mounted in /mnt/smb/"
echo "Mounting $address/$share as $username..."

#Mount the share on /mnt/
sudo mount -t cifs -o username=$username "//$address/$share" /mnt/smb/

#Check if an error occured while mounting
if [ $? -eq 0 ]
then
    echo "$share is mounted!"
else
    echo "Mounting failed..."
fi