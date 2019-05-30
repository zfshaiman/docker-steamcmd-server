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

echo "---Starting MariaDB...---"
screen -S MariaDB -L -Logfile ${SERVER_DIR}/MariaDBLog.0 -d -m mysqld_safe
sleep 10

echo "---Checking for ExileMod---"
if [ ! -d ${SERVER_DIR}/data ]; then
	echo "---ExileMod not found, creating 'data' directory---"
	cd ${SERVER_DIR}
	mkdir ${SERVER_DIR}/data
    cd ${SERVER_DIR}/data
    echo "---Downloading ExileMod Server---"
    wget -q --show-progress ${EXILEMOD_SERVER_URL}
    if [ ! -f ${SERVER_DIR}/data/${EXILEMOD_SERVER_URL##*/} ]; then
    	echo "---Something went wrong, could not find download---"
        sleep infinity
    fi
    unzip ${EXILEMOD_SERVER_URL##*/}
    cp -R ${SERVER_DIR}/data/Arma\ 3\ Server/* ${SERVER_DIR}
    rm -R ${SERVER_DIR}/data/Arma\ 3\ Server/
    rm ${SERVER_DIR}/data/${EXILEMOD_SERVER_URL##*/}
    touch ${SERVER_DIR}/data/"${EXILEMOD_SERVER_URL##*/}_installed"
    if [ ! -d ${SERVER_DIR}/@ExileServer ]; then
    	echo "---Something went wrong, ExileModServer not correctly installed---"
        sleep infinity
    fi
    echo "---ExileMod Server successfully installed---"
    echo "---Downloading ExileMod (this can take some time)---"
    wget -q --show-progress ${EXILEMOD_URL}
	if [ ! -f ${SERVER_DIR}/data/${EXILEMOD_URL##*/} ]; then
		echo "---Something went wrong, could not find download---"
		sleep infinity
    fi
    unzip ${EXILEMOD_URL##*/}
    mv ${SERVER_DIR}/data/@Exile ${SERVER_DIR}
    rm ${SERVER_DIR}/data/${EXILEMOD_URL##*/}
    touch ${SERVER_DIR}/data/"${EXILEMOD_URL##*/}_installed"
    if [ ! -d ${SERVER_DIR}/@Exile ]; then
    	echo "---Something went wrong, ExileMod not correctly installed---"
        sleep infinity
    fi
    echo "---ExileMod successfully installed---"
fi

echo "---Checking if 'exile' database is connected correctly---"
INJECTED="$(mysql -u "steam" -p"exile" -e "USE 'exile'; SHOW TABLES;" | grep 'account')"
if [ "$INJECTED" = "" ] ; then
	echo "---Database not connected, connecting...---"
    mysql -u "steam" -p"exile" -e "SOURCE $SERVER_DIR/data/MySQL/exile.sql"
    if [ "$INJECTED" == "account" ] ; then
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
cp ${DATA_DIR}/steamcmd/linux32/* ${SERVER_DIR}
chmod -R 770 ${DATA_DIR}

echo "---Start Server---"
cd ${SERVER_DIR}
screen -S ArmA3 -L -Logfile ${SERVER_DIR}/Arma3Log.0 -d -m ./arma3server -cfg=@ExileServer/basic.cfg -config=@ExileServer/config.cfg -autoinit -mod=@Exile\; -servermod=@ExileServer\; >> ExileModLog.0 ${GAME_PARAMS}
sleep 2
tail -f ${SERVER_DIR}/MariaDBLog.0 ${SERVER_DIR}/Arma3Log.0 ${SERVER_DIR}/ExileModLog.0