FROM ubuntu

MAINTAINER Mattie

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get -y install libstdc++6:i386
RUN apt-get -y install wget

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="740"
ENV GAME_NAME="csgo"
ENV GAME_PARAMS="+game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2"
ENV GAME_PORT=27015

RUN mkdir $DATA_DIR
RUN mkdir $STEAMCMD_DIR
RUN mkdir $SERVER_DIR
RUN mkdir -p ~/.steam/sdk32

RUN wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz \
  &&  tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz \
  &&  rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz \
  &&  chmod -R 774 ${STEAMCMD_DIR} ${STEAMCMD_DIR}/linux32 $SERVER_DIR \
  &&  ln ${STEAMCMD_DIR}/linux32/ ~/.steam/sdk32
RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 774 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]
