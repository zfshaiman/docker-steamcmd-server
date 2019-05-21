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
if [ ! -f ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/cluster_token.txt ]; then
    echo "---No cluster_token.txt found, downloading template, please create your own to run the server!!!...---"
    if [ ! -d ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1 ]; then
        mkdir ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1
    fi
    cd ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1
    wget -q -O ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/cluster_token.txt https://raw.githubusercontent.com/ich777/docker-steamcmd-server/dontstarve/config/cluster_token.txt
fi
if [ ! -f ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/cluster.ini ]; then
    echo "---No cluster.ini found, downloading template...---"
    if [ ! -d ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1 ]; then
        mkdir ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1
    fi
    cd ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1
    wget -q -O ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/cluster.ini https://raw.githubusercontent.com/ich777/docker-steamcmd-server/dontstarve/config/cluster.ini
fi
if [ ! -f ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/adminlist.txt ]; then
    echo "---No adminlist.txt found, downloading template...---"
    if [ ! -d ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1 ]; then
        mkdir ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1
    fi
    cd ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1
    wget -q -O ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/adminlist.txt https://raw.githubusercontent.com/ich777/docker-steamcmd-server/dontstarve/config/adminlist.txt
fi
if [ ! -f ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master/server.ini ]; then
    echo "---No server.ini found, downloading template...---"
    if [ ! -d ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master ]; then
        mkdir ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master
    fi
    cd ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master
    wget -q -O ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master/server.ini https://raw.githubusercontent.com/ich777/docker-steamcmd-server/dontstarve/config/server.ini
fi
if [ ! -f ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master/worldgenoverride.lua ]; then
    echo "---No worldgenoverride.lua found, downloading template...---"
    if [ ! -d ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master ]; then
        mkdir ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master
    fi
    cd ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master
    wget -q -O ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Master/worldgenoverride.lua https://raw.githubusercontent.com/ich777/docker-steamcmd-server/dontstarve/config/worldgenoverride.lua
fi
if [ "${CAVES}" == "true" ]; then
    if [ ! -f ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Caves/server.ini ]; then
        echo "---No Caves/server.ini found, downloading template...---"
        if [ ! -d ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Caves ]; then
            mkdir ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Caves
        fi
        cd ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Caves
        wget -q -O ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Caves/server.ini https://raw.githubusercontent.com/ich777/docker-steamcmd-server/dontstarve/config/caves_server.ini
    fi
    if [ ! -f ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Caves/worldgenoverride.lua ]; then
        echo "---No Caves/worldgenoverride.lua found, downloading template...---"
        if [ ! -d ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Caves ]; then
            mkdir ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Caves
        fi
        cd ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Caves
        wget -q -O ${DATA_DIR}/.klei/DoNotStarveTogether/Cluster_1/Caves/worldgenoverride.lua https://raw.githubusercontent.com/ich777/docker-steamcmd-server/dontstarve/config/caves_worldgenoverride.lua
    fi
fi
chmod -R 770 ${DATA_DIR}
echo "---Server ready---"

if [ "${CAVES}" == "true" ]; then
    echo "---Checking for old logs---"
    find $SERVER_DIR -name "masterLog.*" -exec rm -f {} \;
    find $SERVER_DIR -name "cavesLog.*" -exec rm -f {} \;
    echo "---Start Server---"
    cd ${SERVER_DIR}/bin
    screen -S Master -L -Logfile $SERVER_DIR/masterLog.0 -d -m ${SERVER_DIR}/bin/dontstarve_dedicated_server_nullrenderer -shard Master
    screen -S Caves -L -Logfile $SERVER_DIR/cavesLog.0 -d -m ${SERVER_DIR}/bin/dontstarve_dedicated_server_nullrenderer -shard Caves
    sleep 2
    tail -f ${SERVER_DIR}/masterLog.0 ${SERVER_DIR}/cavesLog.0
else
    find $SERVER_DIR -name "masterLog.*" -exec rm -f {} \;
    find $SERVER_DIR -name "cavesLog.*" -exec rm -f {} \;
    echo "---Start Server---"
    cd ${SERVER_DIR}/bin
    ${SERVER_DIR}/bin/dontstarve_dedicated_server_nullrenderer -shard Master
fi
