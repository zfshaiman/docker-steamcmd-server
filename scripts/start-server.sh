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
if [ "${DEBUG_OUTPUT}" == "true" ]; then
    ADDITIONAL=""
else
    ADDITIONAL="1>/dev/null"
fi
if [ "${LOG_OUTPUT}" == "true" ]; then
    if [ -z "${LOG_FILE}" ]; then
        echo "---Variable 'LOG_FILE' cannot be empty! Setting name to 'stn.log'!---"
        LOG_FILE="stn.log"
        if [ "${DELETE_LOG}" == "true" ]; then
            rm -rf ${SERVER_DIR}/${LOG_FILE}
        fi
    else
        if [ "${DELETE_LOG}" == "true" ]; then
            rm -rf ${SERVER_DIR}/${LOG_FILE}
        fi
    fi
    ADDITIONAL="| tee -a ${SERVER_DIR}/${LOG_FILE}"
fi
chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Server ready---"

echo "---Sleep zZz...---"
sleep infinity

echo "---Start Server---"
cd ${SERVER_DIR}
eval ${SERVER_DIR}/Server_Linux_x64 ${GAME_PARAMS} ${ADDITIONAL}