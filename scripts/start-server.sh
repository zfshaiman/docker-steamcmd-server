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

if grep -rq 'ServerName="Squad Dedicated Server"' ${SERVER_DIR}/SquadGame/ServerConfig/Server.cfg; then
	echo "---Standard 'Server.cfg' found, downloading custom---"
	cd ${SERVER_DIR}/SquadGame/ServerConfig
    if [ -f ${SERVER_DIR}/SquadGame/ServerConfig/Server.cfg ]; then
    	mv ${SERVER_DIR}/SquadGame/ServerConfig/Server.cfg ${SERVER_DIR}/SquadGame/ServerConfig/Servercfg.bak
	fi
    if wget -q -nc --show-progress --progress=bar:force:noscroll https://raw.githubusercontent.com/ich777/docker-steamcmd-server/squad/config/Server.cfg ; then
    	echo "---Download of custom 'Server.cfg' successfull---"
        if [ -f ${SERVER_DIR}/SquadGame/ServerConfig/Servercfg.bak ]; then
    		rm ${SERVER_DIR}/SquadGame/ServerConfig/Servercfg.bak
		fi
    else
    	echo "-----------------------------------------------------------------------------------------"
		echo "----Something went wrong can't download 'Server.cfg' falling back to standard config!----"
		echo "-----------------------------------------------------------------------------------------"
        if [ -f ${SERVER_DIR}/SquadGame/ServerConfig/Servercfg.bak ]; then
			mv ${SERVER_DIR}/SquadGame/ServerConfig/Servercfg.bak ${SERVER_DIR}/SquadGame/ServerConfig/Server.cfg
		fi
	fi
fi

chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/SquadGameServer.sh ${GAME_PARAMS}