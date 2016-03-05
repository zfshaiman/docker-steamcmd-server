FROM ubuntu

MAINTAINER Mattie

RUN apt-get -y update
RUN apt-get -y install wget
RUN apt-get -y install lib32gcc1

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"

RUN mkdir $DATA_DIR
RUN mkdir $STEAMCMD_DIR
RUN mkdir $SERVER_DIR
RUN cd $STEAMCMD_DIR

EXPOSE 27015
VOLUME [${STEAMCMD_DIR}]

ADD /scripts/ /opt/scripts/
RUN chmod -R 774 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start-csgo.sh"]
