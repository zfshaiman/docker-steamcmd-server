FROM ubuntu

MAINTAINER Mattie

RUN apt-get -y update
RUN apt-get -y install wget
RUN apt-get -y install lib32gcc1

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"


RUN mkdir ${DATA_DIR}
RUN mkdir ${STEAMCMD_DIR}
RUN mkdir ${SEVER_DIR}
RUN cd ${STEAMCMD_DIR}
RUN wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
RUN tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz 
RUN rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz 
RUN chmod -R 774 ${STEAMCMD_DIR}/steamcmd.sh ${STEAMCMD_DIR}/linux32/steamcmd
RUN ${STEAMCMD_DIR}/steamcmd.sh +login anonymous +force_install_dir $SERVER_DIR +app_update 740 validate +quit

EXPOSE 27015
VOLUME [${STEAMCMD_DIR}]

ADD /scripts/ /opt/scripts/
RUN chmod -R 774 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start-csgo.sh"]
