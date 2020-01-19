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

RUN mkdir $DATA_DIR && \
	mkdir $STEAMCMD_DIR && \
	mkdir $SERVER_DIR && \
	useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID steam && \
	chown -R steam $DATA_DIR && \
	ulimit -n 1000000

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/ && \
	chown -R steam /opt/scripts && \
	chmod -R 770 /var/lib/redis && \
	chown -R steam /var/lib/redis && \
	chown -R steam /usr/bin/redis-server && \
	chown -R steam /usr/bin/redis-cli

USER steam

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]