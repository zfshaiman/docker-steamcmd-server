# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Conan Exiles and run it.

**Servername:** 'Docker ConanExiles' Password: 'Docker' rconPassword: 'adminDocker'

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_PARAMS | Values to start the server if needed. | empty |
| WS_CONTENT | Enter you Workshopcontent here, you can also enter more WS Content ID's sperated by SPACE. | empty |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| GAME_PORT | Only change if you know what you are doing (intital GAME_PORT - Dont forget to create create a new UDP port mapping with the corresponding port range and delete the default port range - GAME_PORT +2) | 2456 |
| VALIDATE | Validates the game data | false |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |


## Run example
```
docker run --name Valheim -d \
	-p 7777:7777 -p 7777-7778:7777-7778/udp -p 27015:27015/udp \
	--env 'GAME_ID=443030' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/conanexiles:/serverdata/serverfiles \
	ich777/steamcmd:conanexiles
```


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.

### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/
