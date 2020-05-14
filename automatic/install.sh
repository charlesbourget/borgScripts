#!/usr/bin/env bash

INSTALL_LOCATION="${HOME}/.local/bin/"
CONF_LOCATION="${HOME}/.config/borgScript/"

#Check if installation directory exist
if [[ ! -d ${INSTALL_LOCATION} ]]
then
    mkdir -p ${INSTALL_LOCATION}
fi

#Check if installation directory exist
if [[ ! -d ${CONF_LOCATION} ]]
then
    mkdir -p ${CONF_LOCATION}
fi

#Move to script directory
cd "$(dirname "${BASH_SOURCE[0]}")"

cp createArchiveAuto.sh ${INSTALL_LOCATION}createArchiveAuto

sed -i "s|CONF_LOCATION=\".*\"|CONF_LOCATION=\"${CONF_LOCATION}backup.conf\"|g" "${INSTALL_LOCATION}createArchiveAuto"

cp backup.conf ${CONF_LOCATION}backup.conf

echo "Auto script is now installed in ${INSTALL_LOCATION}\n"
echo "Conf file can be found in ${CONF_LOCATION}"
