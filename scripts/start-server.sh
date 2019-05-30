#!/bin/bash
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "SteamCMD not found!"
    wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
    tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
    rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update SteamCMD---"
if [ "${USERNAME}" == "" ]; then
    echo "Please enter a valid username and password and restart the container. ATTENTION: Steam Guard must be DISABLED!!!"
    sleep infinity
else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login ${USERNAME} ${PASSWRD} \
    +quit
fi

echo "---Update Server---"
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

echo "---Prepare Server---"
if [ ! -f ${SERVER_DIR}/server.cfg ]; then
    echo "---No server.cfg found, downloading...---"
    wget -q -O ${SERVER_DIR}/server.cfg https://raw.githubusercontent.com/ich777/docker-steamcmd-server/arma3/config/server.cfg
else
    echo "---server.cfg found..."
fi
echo "---Starting MariaDB...---"
screen -S MariaDB -L -Logfile ${SERVER_DIR}/MariaDBLog.0 -d -m mysqld
sleep 10


echo "---Prepare Server---"
cp ${DATA_DIR}/steamcmd/linux32/* ${SERVER_DIR}
chmod -R 770 ${DATA_DIR}

sleep infintiy

echo "---Start Server---"
cd ${SERVER_DIR}
screen -S ArmA3 -L -Logfile ${SERVER_DIR}/Arma3Log.0 -d -m ./arma3server ${GAME_PARAMS}
sleep 2
tail -f ${SERVER_DIR}/MariaDBLog.0 ${SERVER_DIR}/Arma3Log.0