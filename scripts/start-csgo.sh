#!/bin/bash
VOLUME=/serverdata

cd /serverdata/steamcmd &&\
    ./steamcmd.sh \
        +login anonymous \
        +force_install_dir /serverdata/csgo \
        +app_update 740 \
        +quit

cd /serverdata/csgo &&\
    ./srcds_run -game csgo -console -usercon +game_type $GAME_TYPE \
                               +game_mode $GAME_MODE \
                               +mapgroup $MAPGROUP \
                               +map $MAP  $OTHER
