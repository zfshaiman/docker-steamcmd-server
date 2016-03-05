FROM ubuntu

MAINTAINER Mattie

RUN apt-get -y update
RUN apt-get -y install wget
RUN apt-get -y install lib32gcc1

RUN mkdir /serverdata
RUN mkdir /serverdata/steamcmd 
RUN mkdir /serverdata/csgo 
RUN cd /serverdata/steamcmd 
RUN wget -q -O /serverdata/steamcmd/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
RUN tar --directory /serverdata/steamcmd -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz 
RUN rm /serverdata/steamcmd/steamcmd_linux.tar.gz 
RUN chmod -R 774 /serverdata/steamcmd/steamcmd.sh /serverdata/steamcmd/linux32/steamcmd
RUN /serverdata/steamcmd/steamcmd.sh +login anonymous +force_install_dir /serverdata/csgo +app_update 740 validate +quit

EXPOSE 27015
VOLUME ["/serverdata"]

ADD /scripts/ /opt/scripts/
RUN chmod -R 774 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start-csgo.sh"]