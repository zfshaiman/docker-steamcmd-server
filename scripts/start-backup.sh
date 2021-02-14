#!/bin/bash
while true
do
	sleep ${BACKUP_INTERVAL}m
	cd ${SERVER_DIR}/.config/unity3d/IronGate/Valheim
	tar -czf ${SERVER_DIR}/Backups/$(date '+%Y-%m-%d_%H.%M.%S').tar .
	cd ${SERVER_DIR}/Backups
	ls -1tr ${SERVER_DIR}/Backups | head -n -10 | xargs -d '\n' rm -f --
	chmod -R ${DATA_PERM} ${SERVER_DIR}/Backups
done