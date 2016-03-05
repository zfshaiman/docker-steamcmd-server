#!/bin/bash

${STEAMCMD_DIR}/steamcmd.sh \
    +login anonymous \
    +force_install_dir $SERVER_DIR \
    +app_update 740 \
    +quit

${SERVER_DIR}/srcds_run \
    -game csgo -console -usercon \
    +game_type $GAME_TYPE \
    +game_mode $GAME_MODE \
    +mapgroup $MAPGROUP \
    +map $MAP  \
    $OTHER
