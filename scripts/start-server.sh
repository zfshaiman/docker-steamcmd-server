#!/bin/bash
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "SteamCMD not found!"
    wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
    tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
    rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update SteamCMD---"
if [ "${USERNAME}" == "" ]; then
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login ${USERNAME} ${PASSWRD} \
    +quit
fi

echo "---Update Server---"
if [ "${USERNAME}" == "" ]; then
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +login anonymous \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +login anonymous \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} \
        +quit
    fi
else
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +login ${USERNAME} ${PASSWRD} \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +login ${USERNAME} ${PASSWRD} \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} \
        +quit
    fi
fi

echo "---Prepare Server---"
export LD_LIBRARY_PATH=${SERVER_DIR}/linux64:$LD_LIBRARY_PATH
export templdpath=$LD_LIBRARY_PATH
chmod -R ${DATA_PERM} ${DATA_DIR}
screen -wipe 2&>/dev/null
echo "---Server ready---"

if [ "${BACKUP_FILES}" == "true" ]; then
    echo "---Starting Backup daemon---"
    if [ ! -d ${SERVER_DIR}/Backups ]; then
        mkdir -p ${SERVER_DIR}/Backups
    fi
    screen -S backup -d -m /opt/scripts/start-backup.sh
fi

echo "---Start Server---"
cd ${SERVER_DIR}
if [ "${DEBUG_OUTPUT}" == "true" ]; then
    ${SERVER_DIR}/valheim_server.x86_64 -name "${SRV_NAME}" -port ${GAME_PORT} -world "${WORLD_NAME}" -password "${SRV_PWD}" -public ${PUBLIC} ${GAME_PARAMS}
else
    ${SERVER_DIR}/valheim_server.x86_64 -name "${SRV_NAME}" -port ${GAME_PORT} -world "${WORLD_NAME}" -password "${SRV_PWD}" -public ${PUBLIC} ${GAME_PARAMS} > /dev/null
fi