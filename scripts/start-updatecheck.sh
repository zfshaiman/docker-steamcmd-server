#!/bin/bash
echo "---Update Check for Valheim enabled, running automatically every ${UPDATE_CHECK_INTERVAL} minutes.---"
UPDATE_CUR_V="$(cat ${SERVER_DIR}/Steam/logs/content_log.txt | grep -oP "BuildID \K\w+" | sort | tail -1)"
if [ -z "${UPDATE_CUR_V}" ]; then
    echo "UPDATE CHECK: ---Something went wrong, can't get current build version for Valheim, disabling Update Check!---"
fi
while true
do
    sleep ${UPDATE_CHECK_INTERVAL}m 
    UPDATE_LAT_V="$(wget -qO- https://api.steamcmd.net/v1/info/896660 | jq -r '.data."'"$GAME_ID"'".depots.branches.public.buildid')"
    if [ -z "${UPDATE_LAT_V}" ]; then
        echo "UPDATE CHECK: ---Something went wrong, can't get latest version of Valheim, trying again in ${UPDATE_CHECK_INTERVAL} minutes!---"
    elif [ "${UPDATE_CUR_V}" != "${UPDATE_LAT_V}" ]; then
        echo "UPDATE CHECK: ---New version of Valheim found, restarting and updating server in 10 seconds---"
        sleep 10
        pkill -SIGINT valheim
        wait "$(pidof valheim_server.x86_64)" -f 2>/dev/null
        sleep 4
        echo 1 > ${SERVER_DIR}/server_exit.drp
        exit 143;
    else
        echo "UPDATE CHECK: ---Nothing to do, Valheim up-to-date---"
    fi
done