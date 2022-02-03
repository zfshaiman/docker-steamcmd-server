#!/bin/bash
echo "---Checking for old logs---"
find ${SERVER_DIR} -name "Arma3Log.0" -exec rm -f {} \;
find ${SERVER_DIR} -name "ExileModLog.0" -exec rm -f {} \;
find ${SERVER_DIR} -name "MariaDBLog.0" -exec rm -f {} \;

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
    +force_install_dir ${SERVER_DIR} \
    +login ${USERNAME} ${PASSWRD} \
    +app_update ${GAME_ID} validate \
    +quit
else
    ${STEAMCMD_DIR}/steamcmd.sh \
    +force_install_dir ${SERVER_DIR} \
    +login ${USERNAME} ${PASSWRD} \
    +app_update ${GAME_ID} \
    +quit
fi

echo "---Starting MariaDB...---"
screen -S MariaDB -L -Logfile ${SERVER_DIR}/MariaDBLog.0 -d -m mysqld_safe
sleep 10

echo "---Checking for ExileMod Server---"
if [ ! -d ${SERVER_DIR}/@ExileServer ]; then
	if [ ! -d ${SERVER_DIR}/data ]; then
		echo "---ExileMod Server not found, creating 'data' directory---"
		cd ${SERVER_DIR}
		mkdir ${SERVER_DIR}/data
		cd ${SERVER_DIR}/data
		echo "---Downloading ExileMod Server---"
		if wget -q -nc --show-progress --progress=bar:force:noscroll ${EXILEMOD_SERVER_URL} ; then
			echo "---Sucessfully downloaded ExileMod Server---"
		else
			echo "---Can't download ExileMod Server, putting server into sleep mode---"
		    sleep infinity
		fi
		unzip ${EXILEMOD_SERVER_URL##*/}
		cp -R ${SERVER_DIR}/data/Arma\ 3\ Server/* ${SERVER_DIR}
		rm -R ${SERVER_DIR}/data/Arma\ 3\ Server/
		rm ${SERVER_DIR}/data/${EXILEMOD_SERVER_URL##*/}
		if [ ! -d ${SERVER_DIR}/@ExileServer ]; then
			echo "---Something went wrong, ExileMod Server not correctly installed---"
			sleep infinity
		fi
		echo "---ExileMod Server successfully installed---"
	fi
else
	echo "---ExileMod Server found!---"
fi

echo "---Checking for ExileMod Files---"
if [ "${WORKSHOP_MAN_INST}" == "true" ]; then
	if [ ! -d ${SERVER_DIR}/steamapps/workshop/content/107410/${WORKSHOP_ID} ]; then
		echo "------------------------------------------------------------------------------"
		echo "---Workshop installation set to manual please install the modfiles manually---"
		echo "--------with this command when you opened a console for the container:--------"
		echo "${STEAMCMD_DIR}/steamcmd.sh +login [USERNAME] +force_install_dir ${SERVER_DIR} +workshop_download_item 107410 1339410397 +quit"
		echo
		echo "-----or with this command when you are running the console from the host:-----"
		echo "docker exec -u steam -ti [NAMEOFYOURCONTAINER] ${STEAMCMD_DIR}/steamcmd.sh +login [USERNAME] +force_install_dir ${SERVER_DIR} +workshop_download_item 107410 1339410397 +quit"
		echo
		echo "-----------Please replace [USERNAME] with your Steam username and-------------"
		echo "-----[NAMEOFYOURCONTAINER] with the name of your containername if you are-----"
		echo "----executing the second command and restart the container if it's finished---"
		echo "----Also please let the variable for the manual installation set to 'true'----"
		echo "------------------------------------------------------------------------------"
		sleep infinity
	else
		if [ ! -d ${SERVER_DIR}/@Exile ]; then
			mkdir ${SERVER_DIR}/@Exile
			mv ${SERVER_DIR}/steamapps/workshop/content/107410/${WORKSHOP_ID}/* ${SERVER_DIR}/@Exile
			INSTALLED_M_V="$(ls -la -d ${SERVER_DIR}/@Exile/* 2>/dev/null | head -1 | cut -d "/" -f 5)"
			if [ -z "$INSTALLED_M_V" ]; then
				echo "---Something went wrong, ExileMod not correctly installed---"
				sleep infinity
			fi
			echo "---ExileMod successfully installed---"
		else
			echo "---ExileMod Files found!---"
		fi
	fi
else
	if [ ! -d ${SERVER_DIR}/@Exile ]; then
		echo "---ExlieMod Files not found, installing---"
		mkdir ${SERVER_DIR}/@Exile
		if [ ! -d ${SERVER_DIR}/steamapps/workshop/content/107410/${WORKSHOP_ID} ]; then
			echo "---ExileMod not found, downloading from Stem Workshop---"
			${STEAMCMD_DIR}/steamcmd.sh \
			+login ${USERNAME} ${PASSWRD} \
			+force_install_dir ${SERVER_DIR} \
			+workshop_download_item 107410 ${WORKSHOP_ID} \
			+quit
			if [ ! -d ${SERVER_DIR}/steamapps/workshop/content/107410/${WORKSHOP_ID} ]; then
				echo
				echo "----------------------------------------------------"
				echo "---Can't download ExileMod, please make sure that---"
				echo "-----the account that you specified has a valid-----"
				echo "--------license/purchase for the game ArmA3---------"
				echo "---itself otherwise the download will always fail!--"
				echo "----------------------------------------------------"
				echo "-----------You can also set the variable:-----------"
				echo "-----------'WORKSHOP_MAN_INST' to 'true'------------"
				echo "----if you want to install the ExileMod manually----"
				echo "----------------------------------------------------"
				echo "-----------Putting server into sleep mode-----------"
				echo "----------------------------------------------------"
				sleep infinity
			fi
			mv ${SERVER_DIR}/steamapps/workshop/content/107410/${WORKSHOP_ID}/* ${SERVER_DIR}/@Exile
			INSTALLED_M_V="$(ls -la -d ${SERVER_DIR}/@Exile/* 2>/dev/null | head -1 | cut -d "/" -f 5)"
			if [ -z "$INSTALLED_M_V" ]; then
				echo "---Something went wrong, ExileMod not correctly installed---"
				sleep infinity
			fi
			echo "---ExileMod successfully installed---"
		fi
	else
		echo "---ExileMod Files found!---"
	fi
fi

echo "---Checking if 'exile' database is connected correctly---"
INJECTED="$(mysql -u "steam" -p"exile" -e "USE 'exile'; SHOW TABLES;" | grep 'account')"
if [ "$INJECTED" = "" ] ; then
	echo "---Database not connected, connecting...---"
	mysql -u "steam" -p"exile" -e "SOURCE $SERVER_DIR/data/MySQL/exile.sql"
	INJECTED="$(mysql -u "steam" -p"exile" -e "USE 'exile'; SHOW TABLES;" | grep 'account')"
	if [ "$INJECTED" = "account" ] ; then
	echo "---Database successfully connected!---"
	else
		echo "---Something went wrong, could not connect database!---"
		sleep infinity
	fi
fi
if [ "$INJECTED" = "account" ] ; then
	echo "---Database setup correct!---"
fi

echo "---Checking if ExileMod is configured correctly for database connection---"
if grep -rq 'Username = changeme' ${SERVER_DIR}/@ExileServer/extdb-conf.ini; then
	sed -i '/Username = changeme/c\Username = steam' ${SERVER_DIR}/@ExileServer/extdb-conf.ini
	sed -i '/Username = steam/!b;n;cPassword = exile' ${SERVER_DIR}/@ExileServer/extdb-conf.ini
	echo "---Corrected ExileMod database connection---"
fi

if grep -rq 'Username = steam' ${SERVER_DIR}/@ExileServer/extdb-conf.ini; then
	if grep -rq 'Password = exile' ${SERVER_DIR}/@ExileServer/extdb-conf.ini; then
		:
	else
		sed -i '/Username = steam/!b;n;cPassword = exile' ${SERVER_DIR}/@ExileServer/extdb-conf.ini
	fi
	echo "---ExileMod database connection correct---"
fi

echo "---Prepare Server---"
cp ${DATA_DIR}/steamcmd/linux64/* ${SERVER_DIR}
chmod -R ${DATA_PERM} ${DATA_DIR}

echo "---Start Server---"
cd ${SERVER_DIR}
screen -S ArmA3 -L -Logfile ${SERVER_DIR}/Arma3Log.0 -d -m ./arma3server_x64 -cfg=@ExileServer/basic.cfg -config=@ExileServer/config.cfg -autoinit -mod=@Exile\; -servermod=@ExileServer\; >> ExileModLog.0 ${GAME_PARAMS}
sleep 2
tail -f ${SERVER_DIR}/MariaDBLog.0 ${SERVER_DIR}/Arma3Log.0 ${SERVER_DIR}/ExileModLog.0