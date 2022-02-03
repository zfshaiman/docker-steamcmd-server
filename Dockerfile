FROM ich777/debian-baseimage

LABEL maintainer="admin@minenet.at"

RUN dpkg --add-architecture i386 && \
	apt-get update && \
	apt-get -y install --no-install-recommends lib32gcc-s1 lib32stdc++6 mariadb-server screen unzip libtbb2:i386 && \
	rm -rf /var/lib/apt/lists/*

ENV DATA_DIR="/serverdata"
ENV STEAMCMD_DIR="${DATA_DIR}/steamcmd"
ENV SERVER_DIR="${DATA_DIR}/serverfiles"
ENV GAME_ID="template"
ENV GAME_NAME="template"
ENV GAME_PARAMS="template"
ENV GAME_PORT=27015
ENV MARIA_DB_ROOT_PWD="ExileMod"
ENV EXILEMOD_SERVER_URL=""
ENV WORKSHOP_ID="1339410397"
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
	useradd -d $DATA_DIR -s /bin/bash $USER && \
	chown -R $USER $DATA_DIR && \
	mkdir -p $DATA_DIR/".local/share/Arma 3" && mkdir -p $DATA_DIR/".local/share/Arma 3 - Other Profiles" && \
	ulimit -n 2048 && \
	/etc/init.d/mariadb start && \
	mysql -u root -e "CREATE USER IF NOT EXISTS 'steam'@'%' IDENTIFIED BY 'exile';FLUSH PRIVILEGES;" && \
	mysql -u root -e "CREATE DATABASE IF NOT EXISTS exile;" && \
	mysql -u root -e "GRANT ALL ON exile.* TO 'steam'@'%' IDENTIFIED BY 'exile';" && \
	mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MARIA_DB_ROOT_PWD';FLUSH PRIVILEGES;" && \
	sed -i '$a\[mysqld]\nsql-mode="ERROR_FOR_DIVISION_BY_ZERO,NO_ZERO_DATE,NO_ZERO_IN_DATE,NO_AUTO_CREATE_USER"' /etc/alternatives/my.cnf

ADD /scripts/ /opt/scripts/
RUN chmod -R 770 /opt/scripts/

#Server Start
ENTRYPOINT ["/opt/scripts/start.sh"]