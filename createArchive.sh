#!/usr/bin/env bash

#Get current date
DATE="$(date +'%Y-%m-%d')"

function question {
    echo $1
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) return 0; break;;
            No ) return 1;
        esac
    done
}

echo "Creating an archive from ~/Documents, ~/Pictures and ~/Videos"
question "This is a question..."

#Check if the share is mounted on /mnt/
if [ ! -d /mnt/backup ]
then
    echo -e "\e[31mThe backup repo which is supposed to be on /mnt/backup does not exist."
    echo -e "\e[39mThis is caused by the share not being mounted or because the repo doesn't exist"
    read -p "Do you want to mount a samba share?[yN] " answer

    if [[ $answer = 'n' ]]
    then
        echo -e "\e[31mBackup can't be executed without a mounted share..."
        exit 1
    elif [[ $answer = 'y' ]]
    then
        #Calls script to mount samba share
        ./mountsmb.sh

        #Check if the operation was successfull
        if [ ! -d /mnt/backup ]
        then
            echo -e "\e[31mShare is still not mounted or repo doesn't exist"
            exit 1
        fi
    else
        echo -e "\e[31mThe answer was not y or n"
        exit 1
    fi
fi

#Check if the archive name is correct
echo "The archive will be named : $DATE"
read -p "Is the name ok?[yN] " answer
echo
if [[ $answer = 'n' ]]
then
    read -p "Enter name for new archive : " name
elif [[ $answer = 'y' ]]
then
    name=$DATE
else
    echo -e "\e[31mThe answer was not y or n"
    exit 1
fi

#Check if an archive with the same name already exist in the repository
expression=$(sudo borg list /mnt/backup | grep -w $name)

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

sudo borg create --progress /mnt/backup::$name ~/Documents ~/Pictures ~/Videos

#Get current time in seconds since UNIX EPOCH
ENDTIME="$(date +%s)"

echo "Backup successfull!"
#Calculate elasped time since start
echo "Backup took $(($ENDTIME - $STARTTIME))s"
echo

read -p "Do you want to unmount the samba share? [yN] " answer

if [[ $answer = 'y' ]]
then
    ./unmountsmb.sh
fi