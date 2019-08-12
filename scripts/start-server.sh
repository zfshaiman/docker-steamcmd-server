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

if [ "${ENA_REDIS}" == "yes" ]; then
	echo "---Starting Redis Server---"
	screen -S RedisServer -d -m /usr/bin/redis-server
	sleep 5
fi

echo "---Prepare Server---"
echo "---Searching for grid files...---"
if [ ! -f ${SERVER_DIR}/ShooterGame/ServerGrid.jpg ]; then
	echo "---ServerGrid.jpg not found, downloading---"
    cd ${SERVER_DIR}/ShooterGame
	wget -qi - https://raw.githubusercontent.com/ich777/docker-steamcmd-server/atlas/grid/ServerGrid.jpg
    if [ ! -f ${SERVER_DIR}/ShooterGame/ServerGrid.jpg ]; then
    	echo "---Something went wrong, couldn't download ServerGrid.jpg---"
        sleep infinity
    fi
else
	echo "---ServerGrid.jpg found!---"
fi
if [ ! -f ${SERVER_DIR}/ShooterGame/ServerGrid.json ]; then
	echo "---ServerGrid.json not found, downloading---"
    cd ${SERVER_DIR}/ShooterGame
	wget -qi - https://raw.githubusercontent.com/ich777/docker-steamcmd-server/atlas/grid/ServerGrid.json
    if [ ! -f ${SERVER_DIR}/ShooterGame/ServerGrid.json ]; then
    	echo "---Something went wrong, couldn't download ServerGrid.json---"
        sleep infinity
    fi
else
	echo "---ServerGrid.json found!---"
fi
if [ ! -f ${SERVER_DIR}/ShooterGame/ServerGrid.ServerOnly.json ]; then
	echo "---ServerGrid.ServerOnly.json not found, downloading---"
    cd ${SERVER_DIR}/ShooterGame
	wget -qi - https://raw.githubusercontent.com/ich777/docker-steamcmd-server/atlas/grid/ServerGrid.ServerOnly.json
    if [ ! -f ${SERVER_DIR}/ShooterGame/ServerGrid.ServerOnly.json ]; then
    	echo "---Something went wrong, couldn't download ServerGrid.ServerOnly.json---"
        sleep infinity
    fi
else
	echo "---ServerGrid.ServerOnly.json found!---"
fi
chmod -R 770 ${DATA_DIR}
echo "---Server ready---"

sleep infinity

echo "---Start Server---"
cd ${SERVER_DIR}/ShooterGame/Binaries/Linux
./ShooterGameServer ${MAP_NAME}${GAME_PARAMS} ${GAME_PARAMS_EXTRA}