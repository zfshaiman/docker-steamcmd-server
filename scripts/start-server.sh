#!/bin/bash
if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
    echo "SteamCMD not found!"
    wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
    tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
    rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

echo "---Update SteamCMD---"
if [ -z "USERNAME" ] then
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +login $USERNAME $PASSWRD \
    +quit
fi

echo "---Update Server---"
if [ -z "USERNAME" ] && [ ! -f then
    echo "You've not entered a Username please execute the following command from the Unraid console for this container: 'docker exec <ContainerName> --user steam /serverdata/steamcmd/steamcmd.sh +login <username> <password> +force_install_dir /serverdata/serverfiles +app_update 233780 validate +quit' please replace the <> with the desctiption. After everything finishes please restart the container."
    sleep infinity
else
    if [ "$VALIDATE" = "true" ]; then
        ${STEAMCMD_DIR}/steamcmd.sh \
        +login $USERNAME $PASSWRD \
        +force_install_dir $SERVER_DIR \
        +app_update $GAME_ID validate \
        +quit
    else
        ${STEAMCMD_DIR}/steamcmd.sh \
        +login $USERNAME $PASSWRD \
        +force_install_dir $SERVER_DIR \
        +app_update $GAME_ID \
        +quit
    fi
fi

echo "---Prepare Server---"
chmod -R 770 ${DATA_DIR}

echo "---Start Server---"
${SERVER_DIR}/arma3server $GAME_PARAMS +port $GAME_PORT
