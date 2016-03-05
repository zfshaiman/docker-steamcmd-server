#Csgo server in docker
The Dockerfile will build an image for running a Counter-Strike: Global Offensive dedicated server.

##Run example
```
docker run --name csgo-server -d \
    --publish 27015:27015 \
	--env 'GAME_TYPE=0' \
	--env 'GAME_MODE=0' \
    --env 'MAPGROUP=mg_active' \
	--env 'MAP=de_dust2' \
	--volume /share/CACHEDEV1_DATA/Public/VM/Docker/CSGO/steamcmd:/serverdata/steamcmd \
	--volume /share/CACHEDEV1_DATA/Public/VM/Docker/CSGO/serverfiles:/serverdata/serverfiles \
	mattie/docker-csgo-server:latest
```
