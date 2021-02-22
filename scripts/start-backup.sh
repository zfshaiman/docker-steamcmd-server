#!/bin/bash
while true
do
	sleep ${BACKUP_INTERVAL}m 
	cd ${SERVER_DIR}/User
	tar -czf ${SERVER_DIR}/Backups/$(date '+%Y-%m-%d_%H.%M.%S').tar.gz .
	cd ${SERVER_DIR}/Backups
	ls -1tr ${SERVER_DIR}/Backups | head -n -${BACKUP_TO_KEEP} | xargs -d '\n' rm -f --
	chmod -R ${DATA_PERM} ${SERVER_DIR}/Backups
done