FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN apt-get update && \
	apt-get -y install --no-install-recommends lib32gcc1 screen file libc6-dev unzip jq && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV SRV_NAME="Valheim Docker"
ENV WORLD_NAME="Dedicated"
ENV SRV_PWD="Docker"
ENV PUBLIC=1
ENV UPDATE_CHECK="true"
ENV UPDATE_CHECK_INTERVAL=60
ENV BACKUP_FILES="true"
ENV BACKUP_INTERVAL=62
ENV BACKUP_TO_KEEP=24
ENV GAME_ID="896660"
ENV DEBUG_OUTPUT=""
ENV LOG_OUTPUT=""
ENV LOG_FILE="valheim.log"
ENV GAME_PARAMS=""
ENV GAME_PORT=2456
ENV ENABLE_VALHEIMPLUS="false"
ENV ENABLE_BEPINEX="false"
ENV VALIDATE=""
ENV UMASK=000
ENV UID=99
ENV GID=100
ENV USERNAME=""
ENV PASSWRD=""
ENV USER="steam"
ENV DATA_PERM=770

RUN mkdir $DATA_DIR && \
	mkdir $STEAMCMD_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $SERVER_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]