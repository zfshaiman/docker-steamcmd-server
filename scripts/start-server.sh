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

if [ ${MOD_LAUNCHER} == "true" ]; then
    echo "---Checking folder structure for 'Creative'---"
fi


echo "---Checking Gamemode---"
if [ ${GAME_MODE} == "Creative" ]; then
    echo "---Checking folder structure for 'Creative'---"
    if [ ! -f ${SERVER_DIR}/Creative ]; then
    	echo "---Folder structure correct...---"	
    else
    	cp -R ${SERVER_DIR}/dist/Creative/ ${SERVER_DIR}/
        echo "---Standard folder structure copied---"
	fi

elif [ ${GAME_MODE} == "Adventure" ]; then
    echo "---Checking folder structure for 'Adventure'---"
    if [ ! -f ${SERVER_DIR}/Adventure ]; then
    	echo "---Folder structure correct...---"	
    else
    	cp -R ${SERVER_DIR}/dist/Adventure/ ${SERVER_DIR}/
        echo "---Standard folder structure copied---"
	fi
else
	echo "---!!!Gamemode not set properly please define 'Creative' or 'Adventure' (without quotes) in the Docker template and restart the Container!!!---"
    sleep infinity
fi


if [ ! -f ${SERVER_DIR}/nativelibs/steamclient.so ]; then
    echo "---Check Steam files---"
    cp $SERVER_DIR/linux64/steamclient.so $SERVEDIR/nativelibs/
fi
echo "---Please wait---"
chmod -R 770 ${DATA_DIR}
echo "---Server ready---"

sleep infinity

echo "---Start Server---"

if [ ${MOD_LAUNCHER} == "true" ]; then
    ${SERVER_DIR}
	${SERVER_DIR}/WurmUnlimited-patched SERVERNAME="${WU_SERVERNAME}" SERVERPASSWORD="${WU_PWD}" ADMINPWD="${WU_ADMINPWD}" MAXPLAYERS="${WU_MAXPLAYERS}" EXTERNALPORT="${GAME_PORT}" QUERYPORT="${WU_QUERYPORT}" HOMESERVER="${WU_HOMESERVER}" HOMEKINGDOM="${WU_HOMEKINGDOM}" LOGINSERVER="${WU_LOGINSERVER}" EPICSETTINGS="${WU_EPICSERVERS}" start=${GAME_MODE} ${GAME_PARAMS}
else
	${SERVER_DIR}
	${SERVER_DIR}/WurmUnlimited SERVERNAME="${WU_SERVERNAME}" SERVERPASSWORD="${WU_PWD}" ADMINPWD="${WU_ADMINPWD}" MAXPLAYERS="${WU_MAXPLAYERS}" EXTERNALPORT="${GAME_PORT}" QUERYPORT="${WU_QUERYPORT}" HOMESERVER="${WU_HOMESERVER}" HOMEKINGDOM="${WU_HOMEKINGDOM}" LOGINSERVER="${WU_LOGINSERVER}" EPICSETTINGS="${WU_EPICSERVERS}" start=${GAME_MODE} ${GAME_PARAMS}
fi