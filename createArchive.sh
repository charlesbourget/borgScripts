#!/usr/bin/env bash

#Get current date
date="$(date +'%Y-%m-%d')"

echo "Creating an archive from ~/Documents, ~/Pictures and ~/Videos"

#Check if the archive name is correct
echo "The archive will be named : $date"
read -p "Is the name ok?[yN] " answer
if [ $answer = 'n' ]
then
    read -p "Enter name for new archive : " name
elif [ $answer = 'y' ]
then
    name=$date
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

#Create the archive
echo "Creating archive..."

sudo borg create --progress /mnt/backup::$name ~/Documents ~/Pictures ~/Videos
