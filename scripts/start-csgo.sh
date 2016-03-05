#!/bin/bash
volumes='ls $DATA_DIR'
echo $volumes
echo "---Update steamcmd---"
${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +quit
echo "---Update server---"
${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +force_install_dir $SERVER_DIR \
    +app_update 740 \
    +quit
echo "---Start Server---"
${SERVER_DIR}/srcds_run \
    -game csgo -console -usercon \
    +game_type $GAME_TYPE \
    +game_mode $GAME_MODE \
    +mapgroup $MAPGROUP \
    +map $MAP  \
    $OTHER
