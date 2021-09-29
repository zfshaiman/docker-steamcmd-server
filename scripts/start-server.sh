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
if [ ! -d ${SERVER_DIR}/Config ]; then
    echo "---Please wait, initializing server!---"
    timeout 10 ${SERVER_DIR}/Server_Linux_x64 >/dev/null 2>&1
    if [ ! -d ${SERVER_DIR}/Config ]; then
        echo "---Something went wrong, can't initialize server!---"
        sleep infinity
    fi
    sed -i '/ServerIP=/c\ServerIP=0.0.0.0' ${SERVER_DIR}/Config/ServerConfig.txt
    sed -i '/ServerName=\"New Private Server\"/c\ServerName=\"StN Docker Server\"' ${SERVER_DIR}/Config/ServerConfig.txt
    sed -i '/ServerPassword=/c\ServerPassword=\"Docker"' ${SERVER_DIR}/Config/ServerConfig.txt
fi
chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
if [ "${DEBUG_OUTPUT}" == "true" ]; then
        ${SERVER_DIR}/Server_Linux_x64 ${GAME_PARAMS}
else
        ${SERVER_DIR}/Server_Linux_x64 ${GAME_PARAMS} > /dev/null
fi