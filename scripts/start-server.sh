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
export DISPLAY=:99
echo "---Checking if everything is in place---"
if [ ! -f ${SERVER_DIR}/Configs/Network.eco ]; then
	echo "---'Network.eco' not found, downloading---"
	cd ${SERVER_DIR}/Configs
	if wget -q -nc --show-progress --progress=bar:force:noscroll -O Network.eco https://raw.githubusercontent.com/ich777/docker-steamcmd-server/eco/config/Network.eco ; then
		echo "---Successfully downloaded 'Network.eco'!---"
	else
		echo "---Something went wrong, can't download 'Network.eco', continuing---"
	fi
else
	echo "---Everything in place---"
fi
echo "---Checking for old logfiles---"
find ${SERVER_DIR} -name "XvfbLog.*" -exec rm -f {} \;
find ${SERVER_DIR} -name "x11vncLog.*" -exec rm -f {} \;
echo "---Checking for old lock files---"
find /tmp -name ".X99*" -exec rm -f {} \;

chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Server ready---"

echo "---Starting Xvfb server---"
screen -S Xvfb -L -Logfile ${SERVER_DIR}/XvfbLog.0 -d -m /opt/scripts/start-Xvfb.sh
sleep 5

if [ "${START_SRV_MGMT}" == "true" ]; then
	echo "---Starting x11vnc server---"
	screen -S x11vnc -L -Logfile ${SERVER_DIR}/x11vncLog.0 -d -m /opt/scripts/start-x11.sh
	sleep 5

	echo "---Starting noVNC server---"
	websockify -D --web=/usr/share/novnc/ --cert=/etc/ssl/novnc.pem 8080 localhost:5900
	sleep 5
fi

echo "---Start Server---"
cd ${SERVER_DIR}
mono ${SERVER_DIR}/EcoServer.exe ${GAME_PARAMS}