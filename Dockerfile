FROM ubuntu

MAINTAINER ich777

RUN apt-get update
RUN apt-get -y install wget lib32gcc1 lib32stdc++6 mariadb-server

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_NAME="template"
ENV GAME_PARAMS="template"
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
RUN mkdir -p $DATA_DIR/".local/share/Arma 3" && mkdir -p $DATA_DIR/".local/share/Arma 3 - Other Profiles"

RUN ulimit -n 2048

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/
RUN chmod -R 770 $DATA_DIR/".local/share/Arma 3" && chmod -R 770 $DATA_DIR/".local/share/Arma 3 - Other Profiles"
RUN chown -R steam /opt/scripts && chown -R steam $DATA_DIR/.local
RUN chown steam:users /var/lib/mysql
RUN chmod -R 770 /var/lib/mysql
RUN mkdir /var/run/mysqld
RUN chown -R steam:users /var/run/mysqld
RUN chmod -R 770 /var/run/mysqld

USER steam

#Server Start
ENTRYPOINT ["/opt/scripts/start-server.sh"]
