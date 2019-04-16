#!/usr/bin/env bash

#Get current date
DATE="$(date +'%Y-%m-%d')"

echo "Creating an archive from ~/Documents, ~/Pictures and ~/Videos"

#Check if the archive name is correct
echo "The archive will be named : $DATE"
read -p "Is the name ok?[yN] " answer
if [ $answer = 'n' ]
then
    read -p "Enter name for new archive : " name
elif [ $answer = 'y' ]
then
    name=$DATE
else
    echo "The answer was not y or n"
    exit 1
fi

#Check if the share is mounted on /mnt/
if [ ! -d /mnt/backup ]
then
    echo "The backup repo which is supposed to be on /mnt/backup does not exist."
    exit 1
fi

#Check if an archive with the same name already exist in the repository
expression=$(sudo borg list /mnt/backup | grep -w $name)

if [ -n "$expression" ]
then
    echo "An archive with this name already exist"
    exit 1
else
    echo "Archive name is unused and valid"
fi

#Create the archive
echo "Creating archive..."

#Get current time in seconds since UNIX EPOCH
STARTTIME="$(date +%s)"

sudo borg create --progress /mnt/backup::$name ~/Documents ~/Pictures ~/Videos

#Get current time in seconds since UNIX EPOCH
ENDTIME="$(date +%s)"

echo "Backup successfull!"
#Calculate elasped time since start
echo "Backup took $(($ENDTIME - $STARTTIME))s"