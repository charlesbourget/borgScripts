#!/usr/bin/env bash

CONF_LOCATION="./backup.conf"

if [[ -f ${CONF_LOCATION} ]]
then
    . ${CONF_LOCATION}
fi

#Get current date
DATE="$(date +'%Y-%m-%d')"

#Check if the share is mounted on /mnt/
if [[ ! -d ${path} ]]
then

    sudo mount -t cifs -o username=$user "//$addr/$share" /mnt/

    #Check if the operation was successfull
    if [[ ! -d ${path} ]]
    then
        echo -e "\e[31mShare is still not mounted or repo doesn't exist"
        exit 1
    fi
fi

#Check if the archive name is correct
echo "The archive will be named : $DATE"

name=${DATE}

#Check if an archive with the same name already exist in the repository
expression=$(sudo borg list ${path} | grep -w ${name})

if [[ -n "$expression" ]]
then
    echo -e "\e[31mAn archive with this name already exist"
    exit 1
else
    echo "Archive name is unused and valid"
fi

#Create the archive
echo "Creating archive..."
echo

#Get current time in seconds since UNIX EPOCH
STARTTIME="$(date +%s)"

sudo borg create --progress --stats ${path}::${name} ~/Documents ~/Pictures ~/Videos

#Get current time in seconds since UNIX EPOCH
ENDTIME="$(date +%s)"

echo "Backup successful!"

#Calculate elapsed time since start
echo "Backup took $(($ENDTIME - $STARTTIME))s"
echo

#Check if a samba share is mounted
if [[ ${path} = "/mnt/backup" ]]
then
    echo "Unmounting /mnt ..."

    sudo umount /mnt
fi
