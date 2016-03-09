#Steamcmd in docker
This dockerfill will download/install steamcmd.
It will also install the server you want(like csgo,tf2,ins ...)

##Env params
| Name | Value | Default |
| --- | --- | --- |
| DATA_DIR | main folder | /serverdata |
| STEAMCMD_DIR | folder for steamcmd | /serverdata/steamcmd |
| SERVER_DIR | folder for gamefile | /serverdata/serverfiles |
| GAME_ID | steamid for server | 740 |
| GAME_NAME | srcds gamename | csgo |
| GAME_PARAMS | values to start the server | +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2 |
| GAME_PORT | port the server will be running on | 27015 |

>**NOTE** GAME_ID values can be found [here](https://developer.valvesoftware.com/wiki/Dedicated_Servers_List)

> And for GAME_NAME there is no list, so a quick search should give you the result

##Run example
```
docker run --name csgo-server -d \
	-p 27015:27015 -p 27015:27015/udp  \
	--env 'GAME_ID=740' \
	--env 'GAME_NAME=csgo' \
	--env 'GAME_PORT=27015' \
	--env 'GAME_PARAMS=+game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2' \
	--volume /share/CACHEDEV1_DATA/Public/VM/Docker/CSGO:/serverdata \
	mattie/docker-steamcmd-server:latest
```
