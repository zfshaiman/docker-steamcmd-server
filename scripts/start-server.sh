#!/bin/bash
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${SERVER_DIR}/Unturned_Headless_Data/Plugins/x86_64/
echo "---Setting umask to ${UMASK}---"
umask ${UMASK}

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

if [ "${ROCKET_MOD}" == "true" ]; then
	if [ ! -f ${SERVER_DIR}/Modules ]; then
    	echo "---Rocket Mod not found, installing---"
		cd ${SERVER_DIR}
		if wget -q -nc --show-progress --progress=bar:force:noscroll ${ROCKET_URL} ; then
        	echo "---Rocketmod download complete---"
        else
        	echo "---Can't download Rocket Mod, putting server into sleep mode---"
            sleep infinity
        fi
		unzip ${SERVER_DIR}/Rocket.zip
        rm Rocket.zip
	else
		echo "---Rocket Mod found---"
    fi
    if [ "${ROCKET_FORCE_UPDATE}" == "true" ]; then
    	echo "---Rocket Mod update forced---"
		cd ${SERVER_DIR}
		if wget -q -nc --show-progress --progress=bar:force:noscroll ${ROCKET_URL} ; then
        	echo "---Rocketmod download complete---"
        else
        	echo "---Can't download Rocket Mod, putting server into sleep mode---"
            sleep infinity
        fi
		unzip -o ${SERVER_DIR}/Rocket.zip
        rm Rocket.zip
    fi
fi

echo "---Prepare Server---"
chmod -R 777 ${DATA_DIR}
if [ ! -f ${SERVER_DIR}/Unturned_Headless_Data/Plugins/x86_64/steamclient.so ]; then
	cp ${STEAMCMD_DIR}/linux64/steamclient.so ${SERVER_DIR}/Unturned_Headless_Data/Plugins/x86_64
fi
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
${SERVER_DIR}/Unturned_Headless.x86_64 -nographics ${GAME_PARAMS} -port:${GAME_PORT} -sv