#!/bin/bash
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

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
        +@sSteamCmdForcePlatformType windows \
        +login anonymous \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +login anonymous \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} \
        +quit
    fi
else
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +login ${USERNAME} ${PASSWRD} \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +login ${USERNAME} ${PASSWRD} \
        +force_install_dir ${SERVER_DIR} \
        +app_update ${GAME_ID} \
        +quit
    fi
fi

echo "---Prepare Server---"
echo "---Checking for 'saves' directory---"
if [ ! -d ${SERVER_DIR}/saves ]; then
	echo "---'saves' not found creating---"
    mkdir ${SERVER_DIR}/saves
fi
echo "---Directory 'saves' found!---"

echo "---Checking for 'config.cfg'---"
if [ ! -f ${SERVER_DIR}/config/config.cfg ]; then
	echo "---'config.cfg' not found downloading---"
    if [ ! -d ${SERVER_DIR}/config ]; then
    	mkdir ${SERVER_DIR}/config
    fi
    cd ${SERVER_DIR}/config
    wget -qi ${SERVER_DIR}/config/config.cfg https://raw.githubusercontent.com/ich777/docker-steamcmd-server/theforest/config/config.cfg
    if [ -f ${SERVER_DIR}/config/config.cfg ]; then
    	echo "---'config.cfg' successfully downloaded---"
    else
    	echo "---Something went wrong, can't download 'config.cfg'---"
        sleep infinity
    fi
fi
chmod -R 777 ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
xvfb-run --auto-servernum --server-args='-screen 0 640x480x24:32' wine ${SERVER_DIR}/TheForestDedicatedServer.exe -batchmode -dedicated -savefolderpath "${SERVER_DIR}/saves/" -configfilepath "${SERVER_DIR}/config/config.cfg" ${GAME_PARAMS}