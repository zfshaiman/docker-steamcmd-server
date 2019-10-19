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
echo "---Checking for 'Game2.ini'---"
if [ ! -f ${SERVER_DIR}/Mordhau/Saved/Config/LinuxServer/Game2.ini ]; then
	echo "---'Game2.ini' not found, downloading---"
    if [ ! -d ${SERVER_DIR}/Mordhau/Saved ]; then
    	mkdir ${SERVER_DIR}/Mordhau/Saved
    fi
    if [ ! -d ${SERVER_DIR}/Mordhau/Saved/Config ]; then
    	mkdir ${SERVER_DIR}/Mordhau/Saved/Config
    fi
    if [ ! -d ${SERVER_DIR}/Mordhau/Saved/Config/LinuxServer ]; then
    	mkdir ${SERVER_DIR}/Mordhau/Saved/Config/LinuxServer
    fi
    cd ${SERVER_DIR}/Mordhau/Saved/Config/LinuxServer
    wget -qO Game2.ini https://raw.githubusercontent.com/ich777/docker-steamcmd-server/mordhau/config/Game2.ini
    if [ ! -f ${SERVER_DIR}/Mordhau/Saved/Config/LinuxServer/Game2.ini ]; then
    	echo "---Something went wrong, can't download 'Game2.ini'---"
        sleep infinity
    fi
else
	echo "---'Game2.ini' found!---"
fi
chmod -R 770 ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/MordhauServer.sh -Port=${GAME_PORT} -QueryPort=${QUERY_PORT} -Beaconport=${BEACON_PORT} -GAMEINI=${SERVER_DIR}/Mordhau/Saved/Config/LinuxServer/Game2.ini -ENGINEINI=${SERVER_DIR}/Mordhau/Saved/Config/LinuxServer/Engine2.ini ${GAME_PARAMS}