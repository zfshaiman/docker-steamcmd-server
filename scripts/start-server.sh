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
if [ "${MOD_LAUNCHER}" == "true" ]; then
	echo "---Checking ModLauncher Version---"
	LAT_V="$(curl -s https://api.github.com/repos/ago1024/WurmServerModLauncher/releases/latest | grep tag_name | cut -d '"' -f4| cut -f2 -d "v")"
	CUR_V="$(find $DATA_DIR -name modlauncher-* | cut -d '-' -f 2,3)"
    if [ -z "$CUR_V" ]; then
       echo "---ModLauncher not found!---"
       cd ${SERVER_DIR}
       curl -s https://api.github.com/repos/ago1024/WurmServerModLauncher/releases/latest \
       | grep "browser_download_url.*server-modlauncher-[^extended].*\.zip" \
       | cut -d ":" -f 2,3 \
       | cut -d '"' -f2 \
       | wget -qi -
       unzip -qo server-modlauncher-$LAT_V.zip
       mv ${SERVER_DIR}/server-modlauncher-$LAT_V.zip ${DATA_DIR}/modlauncher-$LAT_V
       chmod -R 770 *
       ${SERVER_DIR}/patcher.sh
    elif [ "$LAT_V" != "$CUR_V" ]; then
       echo "---Newer version found, installing!---"
       rm ${DATA_DIR}/modlauncher-$CUR_V
       cd ${SERVER_DIR}
       curl -s https://api.github.com/repos/ago1024/WurmServerModLauncher/releases/latest \
       | grep "browser_download_url.*server-modlauncher-[^extended].*\.zip" \
       | cut -d ":" -f 2,3 \
       | cut -d '"' -f2 \
       | wget -qi -
       unzip -qo server-modlauncher-$LAT_V.zip
       mv ${SERVER_DIR}/server-modlauncher-$LAT_V.zip ${DATA_DIR}/modlauncher-$LAT_V
       chmod -R 770 *
       ${SERVER_DIR}/patcher.sh
    elif [ "$LAT_V" == "$CUR_V" ]; then
       echo "---ModLauncher Version up-to-date---"
    else
       echo "---Something went wrong, putting server in sleep mode---"
       sleep infinity
    fi
fi
echo "---Checking folder structure---"
if [ "${GAME_MODE}" == "Creative" ]; then
    echo "---Checking folder structure for 'Creative'---"
    if [ ! -d ${SERVER_DIR}/Creative ]; then
        cp -R ${SERVER_DIR}/dist/Creative/ ${SERVER_DIR}/
        echo "---Standard folder structure copied---"
    else
		echo "---Folder structure correct...---"
	fi
elif [ "${GAME_MODE}" == "Adventure" ]; then
    echo "---Checking folder structure for 'Adventure'---"
    if [ ! -d ${SERVER_DIR}/Adventure ]; then
    	cp -R ${SERVER_DIR}/dist/Adventure/ ${SERVER_DIR}/
        echo "---Standard folder structure copied---"
    else
        echo "---Folder structure correct...---"	
	fi
else
    echo "---Checking folder structure for custom map: '${GAME_MODE}'---"
    if [ ! -f ${SERVER_DIR}/${GAME_MODE}/wurm.ini ]; then
    	echo
    	echo "------------------------------------------------------"
        echo "---Folder structure for '${GAME_MODE}' not correct!---"
        echo "----Putting server in sleepmode, please copy your-----"
        echo "------map to the root of the server and restart-------"
        echo "------------------------------------------------------"
        echo
        sleep infinity
    else
        echo "---Folder structure correct...---"	
	fi
fi
echo "---Checking if LaunchConfig.ini is present---"
if [ ! -f ${SERVER_DIR}/LaunchConfig.ini ]; then
	wget -q -O ${SERVER_DIR}/LaunchConfig.ini https://raw.githubusercontent.com/ich777/docker-steamcmd-server/wurmunlimited/config/LaunchConfig.ini   
    echo "---Downloaded standard LaunchConfig.ini---"
else
	echo "---LaunchConfig.ini present---"
fi
echo "---Checking if Steam file is present---"
if [ ! -f ${SERVER_DIR}/nativelibs/steamclient.so ]; then
    cp ${SERVER_DIR}/linux64/steamclient.so ${SERVER_DIR}/nativelibs/
    echo "---Copied Steam file---"
else
	echo "---Steam file present---"
fi
echo "---Please wait---"
chmod -R 770 ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
if [ "${MOD_LAUNCHER}" == "true" ]; then
    cd ${SERVER_DIR}
	${SERVER_DIR}/WurmServerLauncher-patched SERVERNAME="${WU_SERVERNAME}" SERVERPASSWORD="${WU_PWD}" ADMINPWD="${WU_ADMINPWD}" MAXPLAYERS="${WU_MAXPLAYERS}" EXTERNALPORT="${GAME_PORT}" QUERYPORT="${WU_QUERYPORT}" HOMESERVER="${WU_HOMESERVER}" HOMEKINGDOM="${WU_HOMEKINGDOM}" LOGINSERVER="${WU_LOGINSERVER}" EPICSETTINGS="${WU_EPICSERVERS}" start=${GAME_MODE} ${GAME_PARAMS}
else
	cd ${SERVER_DIR}
	${SERVER_DIR}/WurmServerLauncher SERVERNAME="${WU_SERVERNAME}" SERVERPASSWORD="${WU_PWD}" ADMINPWD="${WU_ADMINPWD}" MAXPLAYERS="${WU_MAXPLAYERS}" EXTERNALPORT="${GAME_PORT}" QUERYPORT="${WU_QUERYPORT}" HOMESERVER="${WU_HOMESERVER}" HOMEKINGDOM="${WU_HOMEKINGDOM}" LOGINSERVER="${WU_LOGINSERVER}" EPICSETTINGS="${WU_EPICSERVERS}" start=${GAME_MODE} ${GAME_PARAMS}
fi