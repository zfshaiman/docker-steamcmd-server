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
if [ ! -d ${SERVER_DIR}/Saves ]; then
    mkdir ${SERVER_DIR}/Saves
fi
if grep -rq '<property name="SaveGameFolder"' ${SERVER_DIR}/${SERVERCONFIG}; then
    if grep -rq '<!-- <property name="SaveGameFolder"' ${SERVER_DIR}/${SERVERCONFIG}; then
        echo "---Moving SaveGameFolder location---"
        sed -i '/<!-- <property name="SaveGameFolder"/c\\t<property name="SaveGameFolder"\t\t\t\t\tvalue="/serverdata/serverfiles/Saves" />' ${SERVER_DIR}/${SERVERCONFIG}
    elif grep -rq 'value="/serverdata/serverfiles/Saves"' ${SERVER_DIR}/${SERVERCONFIG}; then
        echo "---SaveGameFolder location correct---"
    fi
else
    echo "---Creating SaveGameFolder config ---"
    sed -i '4i\    <property name="SaveGameFolder" value="/serverdata/serverfiles/Saves" />\' ${SERVER_DIR}/${SERVERCONFIG}
fi
echo "---Savegame location found---"
if [ ! -d ${SERVER_DIR}/User ]; then
    mkdir ${SERVER_DIR}/User
fi
if grep -rq '<property name="UserDataFolder"' ${SERVER_DIR}/${SERVERCONFIG}; then
    if grep -rq '<!-- <property name="UserDataFolder"' ${SERVER_DIR}/${SERVERCONFIG}; then
        echo "---Moving UserDataFolder location---"
        sed -i '/<!-- <property name="UserDataFolder"/c\\t<property name="UserDataFolder"\t\t\t\t\tvalue="/serverdata/serverfiles/User" />' ${SERVER_DIR}/${SERVERCONFIG}
    elif grep -rq 'value="/serverdata/serverfiles/User"' ${SERVER_DIR}/${SERVERCONFIG}; then
        echo "---UserDataFolder location correct---"
    fi
else
    echo "---Creating UserDataFolder config ---"
    sed -i '4i\    <property name="UserDataFolder" value="/serverdata/serverfiles/User" />\' ${SERVER_DIR}/${SERVERCONFIG}
fi
echo "---UserDataFolder location found---"
chmod -R 770 ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/7DaysToDieServer.x86_64 -configfile=${SERVERCONFIG} ${GAME_PARAMS}



