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
sed -i "/\"ServerName\": \"mom_dedicated\",/c\\\t\"ServerName\": \"MOM Docker Server\"," ${SERVER_DIR}/DedicatedServerConfig.cfg
sed -i "/\"ServerPassword\": \"mom\",/c\\\t\"ServerPassword\": \"Docker\"," ${SERVER_DIR}/DedicatedServerConfig.cfg
sed -i "/\"MaxPlayers\": 2,/c\\\t\"MaxPlayers\": 64," ${SERVER_DIR}/DedicatedServerConfig.cfg
sed -i "/\"Headless\": false,/c\\\t\"Headless\": true," ${SERVER_DIR}/DedicatedServerConfig.cfg

chmod -R ${DATA_PERM} ${DATA_DIR}
chmod +x ${SERVER_DIR}/Game/Binaries/Linux/MemoriesOfMarsServer
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/Game/Binaries/Linux/MemoriesOfMarsServer -MULTIHOME=${MULTIHOME} ${GAME_PARAMS}