#!/bin/bash
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "Steamcmd not found!"
    wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
    tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
    rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update steamcmd---"
${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
    
echo "---Update server---"
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

echo "---Prepare Server---"
if [ ! -d ${DATA_DIR}/.steam/sdk32 ]; then
    mkdir ${DATA_DIR}/.steam/sdk32
    cp -R ${SERVER_DIR}/bin/* ${DATA_DIR}/.steam/sdk32/
    echo "---Server ready---"
else
    echo "---Server ready---"
fi
chmod -R 770 ${DATA_DIR}
   
echo "---Start Server---"
${SERVER_DIR}/srcds_run -game ${GAME_NAME} ${GAME_PARAMS} -console +port ${GAME_PORT}
