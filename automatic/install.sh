#!/usr/bin/env bash

INSTALL_LOCATION="${HOME}/.local/bin/"
CONF_LOCATION="${HOME}/.config/borgScript/"

#Check if installation directory exist
[ -d ${INSTALL_LOCATION} ] || mkdir -p ${INSTALL_LOCATION}

#Check if installation directory exist
[ -d ${CONF_LOCATION} ] || mkdir -p ${CONF_LOCATION}

#Move to script directory
cd "$(dirname "${BASH_SOURCE[0]}")"

cp createArchiveAuto.sh ${INSTALL_LOCATION}createArchiveAuto

sed -i "s|CONF_LOCATION=\".*\"|CONF_LOCATION=\"${CONF_LOCATION}backup.conf\"|g" "${INSTALL_LOCATION}createArchiveAuto"

cp backup.conf ${CONF_LOCATION}backup.conf

echo "Auto script is now installed in ${INSTALL_LOCATION}"
echo "Conf file can be found in ${CONF_LOCATION}"
