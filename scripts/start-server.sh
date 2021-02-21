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
export LD_LIBRARY_PATH=${SERVER_DIR}/linux64:$LD_LIBRARY_PATH
export templdpath=$LD_LIBRARY_PATH
export SteamAppId=892970
chmod -R ${DATA_PERM} ${DATA_DIR}
screen -wipe 2&>/dev/null

if [ "${ENABLE_VALHEIMPLUS}" == "true" ]; then
    echo "---ValheimPlus enabled!---"
    CUR_V="$(find ${SERVER_DIR} -maxdepth 1 -name "ValheimPlus-*" | cut -d '-' -f2)"
    LAT_V="$(wget -qO- https://api.github.com/repos/nxPublic/ValheimPlus/releases/latest | grep tag_name | cut -d '"' -f4 | cut -d 'v' -f2)"
    if [ -z "${LAT_V}" ] && [ -z "${CUR_V}" ]; then
        echo "---Can't get latest version of Valheim Plus!---"
        echo "---Please try to run the Container without ValheimPlus, putting Container into sleep mode!---"
        sleep infinity
    fi

    if [ -f ${SERVER_DIR}/ValheimPlus.zip ]; then
	    rm -rf ${SERVER_DIR}/ValheimPlus.zip
    fi

    echo "---ValheimPlus Version Check---"
    if [ -z "${CUR_V}" ]; then
        echo "---ValheimPlus not found, downloading and installing v$LAT_V...---"
        cd ${SERVER_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/ValheimPlus.zip "https://github.com/nxPublic/ValheimPlus/releases/download/${LAT_V}/UnixServer.zip" ; then
            echo "---Successfully downloaded ValheimPlus v$LAT_V---"
        else
            echo "---Something went wrong, can't download ValheimPlus v$LAT_V, putting container into sleep mode!---"
            sleep infinity
        fi
        unzip -o ${SERVER_DIR}/ValheimPlus.zip
	    touch ${SERVER_DIR}/ValheimPlus-$LAT_V
        rm ${SERVER_DIR}/ValheimPlus.zip
    elif [ "$CUR_V" != "$LAT_V" ]; then
        echo "---Version missmatch, ValheimPlus v$CUR_V installed, downloading and installing v$LAT_V...---"
        cd ${SERVER_DIR}
    	rm -rf ${SERVER_DIR}/ValheimPlus-$CUR_V
        if wget -q -nc --show-progress --progress=bar:force:noscroll -O ${SERVER_DIR}/ValheimPlus.zip "https://github.com/nxPublic/ValheimPlus/releases/download/${LAT_V}/UnixServer.zip" ; then
            echo "---Successfully downloaded ValheimPlus v$LAT_V---"
        else
            echo "---Something went wrong, can't download ValheimPlus v$LAT_V, putting container into sleep mode!---"
            sleep infinity
        fi
        unzip -o ${SERVER_DIR}/ValheimPlus.zip
	    touch ${SERVER_DIR}/ValheimPlus-$LAT_V
        rm ${SERVER_DIR}/ValheimPlus.zip
    elif [ "${CUR_V}" == "${LAT_V}" ]; then
        echo "---ValheimPlus v$CUR_V up-to-date---"
    fi
    if [ "${DEBUG_OUTPUT}" == "true" ]; then
        sed -i '/"${PWD}\/${executable_name}" -name/c\${SERVER_DIR}\/valheim_server.x86_64 -name "${SRV_NAME}" -port ${GAME_PORT} -world "${WORLD_NAME}" -password "${SRV_PWD}" -nographics -batchmode -public ${PUBLIC} ${GAME_PARAMS}' ${SERVER_DIR}/run_bepinex.sh
        sed -i '/${SERVER_DIR}\/valheim_server.x86_64 -name "${SRV_NAME}"/c\${SERVER_DIR}\/valheim_server.x86_64 -name "${SRV_NAME}" -port ${GAME_PORT} -world "${WORLD_NAME}" -password "${SRV_PWD}" -nographics -batchmode -public ${PUBLIC} ${GAME_PARAMS}' ${SERVER_DIR}/run_bepinex.sh
    else
        sed -i '/"${PWD}\/${executable_name}" -name/c\${SERVER_DIR}\/valheim_server.x86_64 -name "${SRV_NAME}" -port ${GAME_PORT} -world "${WORLD_NAME}" -password "${SRV_PWD}" -nographics -batchmode -public ${PUBLIC} ${GAME_PARAMS} > \/dev\/null' ${SERVER_DIR}/run_bepinex.sh
        sed -i '/${SERVER_DIR}\/valheim_server.x86_64 -name "${SRV_NAME}"/c\${SERVER_DIR}\/valheim_server.x86_64 -name "${SRV_NAME}" -port ${GAME_PORT} -world "${WORLD_NAME}" -password "${SRV_PWD}" -nographics -batchmode -public ${PUBLIC} ${GAME_PARAMS} > \/dev\/null' ${SERVER_DIR}/run_bepinex.sh
    fi
    chmod +x ${SERVER_DIR}/run_bepinex.sh
fi
echo "---Server ready---"

if [ "${BACKUP_FILES}" == "true" ]; then
    echo "---Starting Backup daemon---"
    if [ ! -d ${SERVER_DIR}/Backups ]; then
        mkdir -p ${SERVER_DIR}/Backups
    fi
    screen -S backup -d -m /opt/scripts/start-backup.sh
fi

echo "---Start Server---"
cd ${SERVER_DIR}
if [ "${ENABLE_VALHEIMPLUS}" == "true" ]; then
    ${SERVER_DIR}/run_bepinex.sh
else
    if [ "${DEBUG_OUTPUT}" == "true" ]; then
        ${SERVER_DIR}/valheim_server.x86_64 -name "${SRV_NAME}" -port ${GAME_PORT} -world "${WORLD_NAME}" -password "${SRV_PWD}" -public ${PUBLIC} ${GAME_PARAMS}
    else
        ${SERVER_DIR}/valheim_server.x86_64 -name "${SRV_NAME}" -port ${GAME_PORT} -world "${WORLD_NAME}" -password "${SRV_PWD}" -public ${PUBLIC} ${GAME_PARAMS} > /dev/null
    fi
fi