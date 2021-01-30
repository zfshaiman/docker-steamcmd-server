#!/bin/bash
DL_URL_MULTIADMIN="$(curl -s https://api.github.com/repos/ServerMod/MultiAdmin/releases/latest | grep browser_download_url | cut -d ":" -f 2,3 | cut -d '"' -f2)"
DL_URL_SERVERMOD="$(curl -s https://api.github.com/repos/ServerMod/Smod2/releases/latest | grep browser_download_url | cut -d ":" -f 2,3 | cut -d '"' -f2)"

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

echo "---Installing MultiAdmin---"
if [ "${VALIDATE}" == "true" ]; then
	if [ -f ${SERVER_DIR}/MultiAdmin.exe ]; then
    	rm  ${SERVER_DIR}/MultiAdmin.exe
    fi
    cd ${SERVER_DIR}
	if wget -q $DL_URL_MULTIADMIN ; then
		echo "---MultiAdmin sucessfully verified---"
	else
		echo "---Couldn't download MultiAdmin, putting server into sleep mode---"
		sleep infinity
	fi
else
    if [ ! -f ${SERVER_DIR}/MultiAdmin.exe ]; then
    	cd ${SERVER_DIR}
        if wget -q $DL_URL_MULTIADMIN ; then
            echo "---MultiAdmin sucessfully installed---"
        else
            echo "---Couldn't download MultiAdmin, putting server into sleep mode---"
            sleep infinity
        fi
    else
        echo "---MultiAdmin found---"
	fi
fi

echo "---Installing ServerMod---"
if [ "${VALIDATE}" == "true" ]; then
	if [ -f ${SERVER_DIR}/Assembly-CSharp.dll ]; then
    	rm  ${SERVER_DIR}/Assembly-CSharp.dll
    fi
    if [ -f ${SERVER_DIR}/Smod2.dll ]; then
    	rm  ${SERVER_DIR}/Smod2.dll
    fi
    cd ${SERVER_DIR}
	if wget -q $DL_URL_SERVERMOD ; then
		echo "---ServerMod sucessfully verified---"
	else
		echo "---Couldn't download ServerMod, putting server into sleep mode---"
		sleep infinity
	fi
else
	DL_URL_SERVERMOD=(${DL_URL_SERVERMOD[@]})
    if [ ! -f ${SERVER_DIR}/Assembly-CSharp.dll ]; then
    	echo "---File from ServerMod missing, installing---"
    	cd ${SERVER_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll ${DL_URL_SERVERMOD[0]} ; then
            echo "---Assembly-Csharp.dll sucessfully installed---"
        else
            echo "---Couldn't download Assembly-Csharp.dll, putting server into sleep mode---"
            sleep infinity
        fi
    fi
    if [ ! -f ${SERVER_DIR}/Smod2.dll ]; then
    	echo "---File from ServerMod missing, installing---"
    	cd ${SERVER_DIR}
        if wget -q -nc --show-progress --progress=bar:force:noscroll ${DL_URL_SERVERMOD[1]} ; then
            echo "---Smod2.dll sucessfully installed---"
        else
            echo "---Couldn't download Smod2.dll, putting server into sleep mode---"
            sleep infinity
        fi
	fi
    if [ -f ${SERVER_DIR}/Assembly-CSharp.dll ] && [ -f ${SERVER_DIR}/Smod2.dll ]; then
    	echo "---ServerMod found---"
	fi
fi


#Temporary fix for Logfile ballooning
if [ ! -f ${SERVER_DIR}/scp_multiadmin.cfg ]; then
    echo 'multiadmin_nolog: true' > ${SERVER_DIR}/scp_multiadmin.cfg
else
    if [ -z "$(grep "multiadmin_nolog: true" ${SERVER_DIR}/scp_multiadmin.cfg)" ]; then
        echo 'multiadmin_nolog: true' >> ${SERVER_DIR}/scp_multiadmin.cfg
    fi
fi
if [ ! -z "$(ls -A ${SERVER_DIR}/logs)" ]; then
   rm -rf ${SERVER_DIR}/logs/*
fi
#Temporary fix end


echo "---Prepare Server---"
chmod -R ${DATA_PERM} ${DATA_DIR}
echo "---Checking for old logs---"
find ${SERVER_DIR} -name "masterLog.*" -exec rm -f {} \;
echo "---Server ready---"

echo "---Start Server---"
cd ${SERVER_DIR}
#Temporary fix for Logfile ballooning
#screen -S SCP -L -Logfile ${SERVER_DIR}/masterLog.0 -d -m mono MultiAdmin.exe ${GAME_PARAMS}
screen -S SCP -d -m mono MultiAdmin.exe ${GAME_PARAMS}
echo 'Logging disabled to preven logfile ballooning' > ${SERVER_DIR}/masterLog.0
sleep 2
tail -f ${SERVER_DIR}/masterLog.0