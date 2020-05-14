#!/usr/bin/env bash

set -e

#Load configuration from file
CONF_LOCATION="./backup.conf"

if [[ -f ${CONF_LOCATION} ]]
then
    . ${CONF_LOCATION}
fi

#Ping backup server to check if the address is valid
ping -c 1 ${addr}

echo "Server address is valid and server is available"

#Add repo passphrase to env variable
export BORG_PASSPHRASE=${borg_passphrase}

#Get current date
DATE="$(date +'%Y-%m-%d')"

#Check if the share is mounted on /mnt/
[ -d ${path} ] || (mount -t cifs -o username=$user "//$addr/$share" /mnt/ && [ -d ${path} ])

echo "Repo is available"

#Check if the archive name is correct
echo "The archive will be named : $DATE"

name=${DATE}

#Check if an archive with the same name already exist in the repository
borg list ${path} | grep -w ${name} && (echo -e "\e[31mArchive name is already in use"; exit 1)

echo "Archive name is unused and valid"

#Create the archive
echo "Creating archive..."
echo

#Get current time in seconds since UNIX EPOCH
STARTTIME="$(date +%s)"

borg create --progress --stats ${path}::${name} ~/Documents ~/Pictures ~/Videos

#Get current time in seconds since UNIX EPOCH
ENDTIME="$(date +%s)"

echo "Backup successful!"

#Calculate elapsed time since start
echo "Backup took $(($ENDTIME - $STARTTIME))s"
echo

echo "Unmounting /mnt ..."

umount /mnt
