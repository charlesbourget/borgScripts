#!/usr/bin/env bash

#Get current date
DATE="$(date +'%Y-%m-%d')"

#Ask a Yes/No question to the user
#Return 0 if the answer is Yes
#Return 1 if the answer is No
function question {
    echo ${1}
    select answer in "Yes" "No"; do
        case $answer in
            Yes ) return 0; break;;
            No ) return 1;
        esac
    done
}

#Default is to back up all three directory
echo "Creating an archive from ~/Documents, ~/Pictures and ~/Videos"

echo "Is the backup to a samba share or a local drive?"
select answer in "Samba" "Local"; do
    case $answer in
       "Samba" )
            response=0
            break;;
        "Local" )
            response=1
            break;;
    esac
done

if [[ ${response} = 1 ]]
then
    read -p "Enter path to repo on local disk. " path

    #Check if path exist
    if [[ ! -d ${path} ]]
    then
        echo "The repo specified does not exist"
        exit 1
    fi
else
    #Ask for auto mode
    read -p "Enter 'y' to use the automatic mode: " auto
    if [[ $auto == "y" ]]
    then
        ./createArchiveAuto.sh
        exit 0
    fi

    path="/mnt/backup"
    #Check if the share is mounted on /mnt/
    if [[ ! -d ${path} ]]
    then
        echo -e "\e[31mThe backup repo which is supposed to be on /mnt/backup does not exist."
        echo -e "\e[39mThis is caused by the share not being mounted or because the repo doesn't exist"
        question "Do you want to mount a samba share?"
        answer=$?

        if [[ ${answer} = 1 ]]
        then
            echo -e "\e[31mBackup can't be executed without a mounted share..."
            exit 1
        elif [[ ${answer} = 0 ]]
        then
            #Calls script to mount samba share
           ./mountsmb.sh

            #Check if the operation was successfull
            if [[ ! -d ${path} ]]
            then
                echo -e "\e[31mShare is still not mounted or repo doesn't exist"
                exit 1
            fi
        else
            echo -e "\e[31mThe answer was not y or n"
            exit 1
        fi
    fi
fi

#Check if the archive name is correct
echo "The archive will be named : $DATE"
question "Is the name ok?"
answer=$?

if [[ ${answer} = 1 ]]
then
    read -p "Enter name for new archive : " name
elif [[ ${answer} = 0 ]]
then
    name=${DATE}
fi

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

sudo borg create --progress ${path}::${name} ~/Documents ~/Pictures ~/Videos

#Get current time in seconds since UNIX EPOCH
ENDTIME="$(date +%s)"

echo "Backup successful!"

#Calculate elapsed time since start
echo "Backup took $(($ENDTIME - $STARTTIME))s"
echo

#Check if a samba share is mounted
if [[ ${path} = "/mnt/backup" ]]
then
    #Ask if the user want to unmount the samba share
    question "Do you want to unmount the samba share?"
    answer=$?

    if [[ ${answer} = 0 ]]
    then
        ./unmountsmb.sh
    fi
fi
