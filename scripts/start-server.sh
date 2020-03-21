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
    +@sSteamCmdForcePlatformType windows \
    +login ${USERNAME} ${PASSWRD} \
    +force_install_dir ${SERVER_DIR} \
    +app_update ${GAME_ID} validate \
    +quit
else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +@sSteamCmdForcePlatformType windows \
    +login ${USERNAME} ${PASSWRD} \
    +force_install_dir ${SERVER_DIR} \
    +app_update ${GAME_ID} \
    +quit
fi

if [ "${INSTALL_STRACKER}" == "true" ]; then
echo "---Searching for Stracker installation---"
    if [ ! -f ${SERVER_DIR}/stracker/stracker_linux_x86/stracker ]; then
		echo "---Stracker not found, downloading and installing---"
		if [ ! -d ${SERVER_DIR}/stracker ]; then
			mkdir ${SERVER_DIR}/stracker
		fi
		cd ${SERVER_DIR}/stracker
		if wget -q -nc --show-progress --progress=bar:force:noscroll -O stracker.zip https://github.com/ich777/runtimes/raw/master/stracker/stracker.zip ; then
			echo "---Successfully downloaded Stracker!---"
		else
			echo "---Something went wrong, can't download Stracker, putting server in sleep mode---"
			sleep infinity
		fi
		unzip -o stracker.zip
		rm ${SERVER_DIR}/stracker/stracker.zip
		tar -xvzf stracker_linux_x86.tgz
		rm ${SERVER_DIR}/stracker/stracker_linux_x86.tgz
		rm ${SERVER_DIR}/stracker/start-stracker.cmd
		if [ -f ${SERVER_DIR}/stracker.ini ]; then
			echo "---Old stracker.ini found, copying!---"
			cp ${SERVER_DIR}/stracker.ini ${SERVER_DIR}/stracker/stracker_linux_x86/stracker.ini
			rm ${SERVER_DIR}/stracker/stracker-default.ini
		else
			mv ${SERVER_DIR}/stracker/stracker-default.ini ${SERVER_DIR}/stracker/stracker_linux_x86/stracker.ini
		fi
	else
		echo "---Stracker found, continuing---"
	fi
else
	if [ -d ${SERVER_DIR}/stracker ]; then
		echo "---Old stracker installation found, removing and backing up stracker.ini---"
		if [ -f ${SERVER_DIR}/stracker/stracker_linux_x86/stracker.ini ]; then
			cp ${SERVER_DIR}/stracker/stracker_linux_x86/stracker.ini ${SERVER_DIR}/stracker.ini
			echo "---'stracker.ini' backed up to main directory---"
		else
			echo "---Can't find old 'stracker.ini', continuing---"
		fi
		rm -R ${SERVER_DIR}/stracker
	fi
	if [ -f ${SERVER_DIR}/stracker.log ]; then
		rm ${SERVER_DIR}/stracker.log
	fi
	if [ -f ${SERVER_DIR}/AC.log ]; then
		rm ${SERVER_DIR}/AC.log
	fi
fi

echo "---Prepare Server---"
if [ "${INSTALL_STRACKER}" == "true" ]; then
	echo "---Checking if Server is configured properly---"
	sed -i '/UDP_PLUGIN_ADDRESS/c\UDP_PLUGIN_ADDRESS=127.0.0.1:12000' ${SERVER_DIR}/cfg/server_cfg.ini
	sed -i '/UDP_PLUGIN_LOCAL_PORT/c\UDP_PLUGIN_LOCAL_PORT=11000' ${SERVER_DIR}/cfg/server_cfg.ini
	sed -i '/ac_server_cfg_ini =/c\ac_server_cfg_ini = /serverdata/serverfiles/cfg/server_cfg.ini' ${SERVER_DIR}/stracker/stracker_linux_x86/stracker.ini
	sed -i '/log_file =/c\log_file = /serverdata/serverfiles/stracker.log' ${SERVER_DIR}/stracker/stracker_linux_x86/stracker.ini
	echo "---Checking for old logs---"
	find ${SERVER_DIR} -name "AC.log" -exec rm -f {} \;
	find ${SERVER_DIR} -name "stracker.log" -exec rm -f {} \;
else
	sed -i '/UDP_PLUGIN_ADDRESS/c\UDP_PLUGIN_ADDRESS=' ${SERVER_DIR}/cfg/server_cfg.ini
	sed -i '/UDP_PLUGIN_LOCAL_PORT/c\UDP_PLUGIN_LOCAL_PORT=0' ${SERVER_DIR}/cfg/server_cfg.ini
fi
chmod -R ${DATA_PERM} ${DATA_DIR}

sleep infinity

echo "---Start Server---"
if [ "${INSTALL_STRACKER}" == "true" ]; then
	cd ${SERVER_DIR}
	screen -S AssettoCorsa -L -Logfile ${SERVER_DIR}/AC.log -d -m ${SERVER_DIR}/acServer
	sleep 10
	cd ${SERVER_DIR}/stracker/stracker_linux_x86
	screen -S Stracker -L -d -m ${SERVER_DIR}/stracker/stracker_linux_x86/stracker --stracker_ini ${SERVER_DIR}/stracker/stracker_linux_x86/stracker.ini
	sleep 2
	tail -f ${SERVER_DIR}/AC.log ${SERVER_DIR}/stracker.log
else
	cd ${SERVER_DIR}
	${SERVER_DIR}/acServer
fi