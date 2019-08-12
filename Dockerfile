FROM ubuntu

MAINTAINER ich777

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install lib32gcc1 wget perl-modules curl lsof libc6-i386 bzip2 jq libssl1.0.0 libidn11 redis-server screen

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_NAME="template"
ENV GAME_PARAMS="template"
ENV GAME_EXTRA_PARAMS="template"
ENV MAP_NAME="Ocean"
ENV GAME_PORT=27015
ENV VALIDATE=""
ENV UID=99
ENV GID=100
ENV USERNAME=""
ENV PASSWRD=""

RUN mkdir $DATA_DIR
RUN mkdir $STEAMCMD_DIR
RUN mkdir $SERVER_DIR
RUN useradd -d $DATA_DIR -s /bin/bash --uid $UID --gid $GID steam
RUN chown -R steam $DATA_DIR

RUN ulimit -n 1000000

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chown -R steam /opt/scripts
RUN chmod -R 770 /var/lib/redis
RUN chown -R steam /var/lib/redis
RUN chown -R steam /usr/bin/redis-server
RUN chown -R steam /usr/bin/redis-cli

USER steam

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]