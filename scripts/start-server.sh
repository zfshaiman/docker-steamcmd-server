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
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir ${SERVER_DIR} \
        +login anonymous \
        +app_update ${GAME_ID} \
        +quit
    fi
else
    if [ "${VALIDATE}" == "true" ]; then
    	echo "---Validating installation---"
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir ${SERVER_DIR} \
        +login ${USERNAME} ${PASSWRD} \
        +app_update ${GAME_ID} validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +@sSteamCmdForcePlatformType windows \
        +force_install_dir ${SERVER_DIR} \
        +login ${USERNAME} ${PASSWRD} \
        +app_update ${GAME_ID} \
        +quit
    fi
fi

echo "---Prepare Server---"
echo "---Checking for 'server.cfg'---"
if [ ! -f ${SERVER_DIR}/reactivedrop/cfg/server.cfg ]; then
    cd ${SERVER_DIR}/reactivedrop/cfg
    if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-steamcmd-server/alienswarmreactivedrop/config/server.cfg ; then
		echo "---Successfully downloaded 'server.cfg'---"
	else
		echo "---Something went wrong, can't download 'server.cfg', putting server in sleep mode---"
		sleep infinity
	fi
fi
export WINEARCH=win64
export WINEPREFIX=/serverdata/serverfiles/WINE64
export DISPLAY=:99
echo "---Checking if WINE workdirectory is present---"
if [ ! -d ${SERVER_DIR}/WINE64 ]; then
	echo "---WINE workdirectory not found, creating please wait...---"
	mkdir ${SERVER_DIR}/WINE64
else
	echo "---WINE workdirectory found---"
fi
echo "---Checking if WINE is properly installed---"
if [ ! -d ${SERVER_DIR}/WINE64/drive_c/windows ]; then
	echo "---Setting up WINE---"
	cd ${SERVER_DIR}
	winecfg > /dev/null 2>&1
	sleep 15
else
	echo "---WINE properly set up---"
fi
echo "---Checking for old display lock files---"
find /tmp -name ".X99*" -exec rm -f {} \; > /dev/null 2>&1
echo "---Checking for old logfiles---"
find ${SERVER_DIR} -name "masterLog.*" -exec rm -f {} \; > /dev/null 2>&1
find ${SERVER_DIR} -name "XvfbLog.*" -exec rm -f {} \; > /dev/null 2>&1
chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Server ready---"

echo "---Starting Xvfb server---"
screen -S Xvfb -L -Logfile ${SERVER_DIR}/XvfbLog.0 -d -m /opt/scripts/start-Xvfb.sh
sleep 5

echo "---Start Server---"
cd ${SERVER_DIR}
screen -S AlienSwarm-ReactiveDrop -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m wine64 start srcds.exe -console -game ${GAME_NAME} ${GAME_PARAMS} +port ${GAME_PORT}
sleep 5
tail -f ${SERVER_DIR}/masterLog.0