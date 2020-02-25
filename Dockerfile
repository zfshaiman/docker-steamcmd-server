FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get -y install --no-install-recommends lib32gcc1 perl-modules curl lsof libc6-i386 bzip2 jq libssl1.1 libidn11 redis-server screen && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_PARAMS="template"
ENV GAME_PARAMS_EXTRA="template"
ENV MAP_NAME="Ocean"
ENV GAME_PORT=27015
ENV VALIDATE=""
ENV ENA_REDIS=""
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
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	ulimit -n 1000000

ADD /scripts/ /opt/scripts/
COPY /libcrypto.so.1.0.0 	/usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0
COPY /libssl.so.1.0.0 	/usr/lib/x86_64-linux-gnu/libssl.so.1.0.0
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]