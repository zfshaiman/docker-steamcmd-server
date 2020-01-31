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
echo "---Looking for config file---"
if [ ! -d ${SERVER_DIR}/DaysOfWar/Saved/Config/LinuxServer ]; then
	if [ ! -d ${SERVER_DIR}/DaysOfWar ]; then
    	echo "-----------------------------------------------------------"
    	echo "---Something went wrong can't find folder 'DaysOfWar'---"
    	echo "--------------Putting Server into sleep mode---------------"
    	sleep infinity
    	fi
    if [ ! -d ${SERVER_DIR}/DaysOfWar/Saved ]; then
		mkdir ${SERVER_DIR}/DaysOfWar/Saved
    fi
	if [ ! -d ${SERVER_DIR}/DaysOfWar/Saved/Config ]; then
		mkdir ${SERVER_DIR}/DaysOfWar/Saved/Config
    fi
    if [ ! -d ${SERVER_DIR}/DaysOfWar/Saved/Config/LinuxServer ]; then
		mkdir ${SERVER_DIR}/DaysOfWar/Saved/Config/LinuxServer
    fi
fi
if [ ! -f ${SERVER_DIR}/DaysOfWar/Saved/Config/LinuxServer/Game.ini ]; then
	echo "---'Game.ini' not found, downloading template---"
    cd ${SERVER_DIR}/DaysOfWar/Saved/Config/LinuxServer
	if wget -q -nc --show-progress --progress=bar:force:noscroll https://github.com/ich777/docker-steamcmd-server/raw/daysofwar/config/Game.ini ; then
		echo "---Sucessfully downloaded 'Game.ini'---"
	else
		echo "---Something went wrong, can't download 'Game.ini', putting server in sleep mode---"
		sleep infinity
	fi
else
	echo "---'Game.ini' found---"
fi

chmod -R 777 ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/DaysOfWarServer.sh ${GAME_PARAMS} Port=${GAME_PORT} QueryPort=${QUERY_PORT}