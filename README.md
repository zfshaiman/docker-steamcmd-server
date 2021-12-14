# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install 7DaysToDie and run it.

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to use a static version of the game and not always the latest one then enter this: '294420 -beta stable_alpha19.4' or '294420 -beta latest_experimental' (without quotes) if you want to stay for example on alpha19.4. | 294420 |
| SERVERCONFIG | Please change if your serverconfigfile has another name. | serverconfig.xml |
| GAME_PARAMS | Values to start the server | -logfile 7DaysToDie_Data/output_log.txt $@ |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | false |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |


## Run example
```
docker run --name 7DtD -d \
	-p 26900:26900 -p 26900-26903:26900-26903/udp -p 27015:27015/udp -p 8080:8080 -p 8082:8082 \
	--env 'GAME_ID=294420' \
	--env 'SERVERCONFIG=serverconfig.xml' \
	--env 'GAME_PARAMS=-logfile 7DaysToDie_Data/output_log.txt $@' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/7dtd:/serverdata/serverfiles \
	ich777/steamcmd:7dtd
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.

### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/