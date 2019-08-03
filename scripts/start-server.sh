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
chmod -R 770 ${DATA_DIR}
find ${SERVER_DIR} -name "masterLog.*" -exec rm -f {} \;
echo "---Checking if everything is in place---"
if [ ! -f ${DATA_DIR}/.steam/sdk64/steamclient.so ]; then
    echo "---Moving files in place---"
	if [ ! -d ${DATA_DIR}/.steam/sdk64 ]; then
    	mkdir ${DATA_DIR}/.steam/sdk64
    fi
	cp ${SERVER_DIR}/linux64/steamclient.so ${DATA_DIR}/.steam/sdk64/steamclient.so
    sleep 2
   	if [ ! -f ${DATA_DIR}/.steam/sdk64/steamclient.so ]; then
    	echo "---Something went wrong, couldn't move steamclient.so putting server into sleep mode---"
        sleep infinity
    fi
    echo "---Everyting moved correctly---"
fi
echo "---Everyting is in place---"
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
colonyserver.x86_64 -batchmode -nographics +server.name "${SRV_NAME}" +server.networktype ${SRV_NETTYPE} +server.world ${SRV_WORLDNAME} ${GAME_PARAMS}