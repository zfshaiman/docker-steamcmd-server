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
if [ ! -f ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/cluster_token.txt ]; then
    echo "---No cluster_token.txt found, downloading template, please create your own to run the server!!!...---"
    wget -q -O ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/cluster_token.txt https://raw.githubusercontent.com/ich777/docker-steamcmd-server/dontstarve/config/cluster_token.txt
fi
if [ ! -f ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/cluster.ini ]; then
    echo "---No cluster.ini found, downloading template...---"
    wget -q -O ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/cluster.ini https://raw.githubusercontent.com/ich777/docker-steamcmd-server/dontstarve/config/cluster.ini
fi
if [ ! -f ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master/server.ini ]; then
    echo "---No server.ini found, downloading template...---"
    wget -q -O ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master/server.ini https://raw.githubusercontent.com/ich777/docker-steamcmd-server/dontstarve/config/server.ini
fi
chmod -R 770 ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}/bin
${SERVER_DIR}/bin/dontstarve_dedicated_server_nullrenderer



