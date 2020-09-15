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
echo "---Checking for 'serversettings.xml'---"
if [ ! -f ${SERVER_DIR}/serversettings.xml ]; then
    echo "---No 'serversettings.xml' found, downloading...---"
    cd ${SERVER_DIR}
    if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-steamcmd-server/barotrauma/config/serversettings.xml ; then
    	echo "---Sucessfully downloaded 'serversettings.xml'---"
	else
    	echo "Can't download 'serversettings.xml', putting server into sleep mode---"
        sleep infinity
	fi
else
    echo "---'serversettings.xml' found..."
fi
echo "---Checking if everything is in place---"
if [ ! -f ${DATA_DIR}/.steam/sdk64/steamclient.so ]; then
	echo "---Correcting errors---"
	if [ ! -d ${DATA_DIR}/.steam/sdk64 ]; then
		mkdir -p ${DATA_DIR}/.steam/sdk64
	fi
	cp ${STEAMCMD_DIR}/linux64/steamclient.so ${DATA_DIR}/.steam/sdk64/
	if [ ! -f ${STEAMCMD_DIR}/linux64/steamclient.so ]; then
		echo "---Something went wrong, can't copy 'steamclient.so' putting server into sleep mode---"
		sleep infinity
	fi
	echo "---Errors corrected---"
else
	echo "---Everything is in place---"
fi
sed -i '/name="Server"/c\  name="DockerServer"' ${SERVER_DIR}/serversettings.xml
chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Checking for old logs---"
find ${SERVER_DIR} -name "masterLog.*" -exec rm -f {} \;
screen -wipe 2&>/dev/null

echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
screen -S Barotrauma -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m ${SERVER_DIR}/DedicatedServer ${GAME_PARAMS}
sleep 2
screen -S watchdog -d -m /opt/scripts/start-watchdog.sh
tail -f ${SERVER_DIR}/masterLog.0