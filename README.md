# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install TeamFortress2 and run it.

Update Notice: Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to install a static or beta version of the game change the value to: '232250 -beta YOURBRANCH' (without quotes, replace YOURBRANCH with the branch or version you want to install). | 232250 |
| GAME_NAME | SRCDS gamename | tf |
| GAME_PARAMS | Values to start the server | +sv_pure 1 +randommap +maxplayers 24 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| GAME_PORT | Port the server will be running on | 27015 |

## Run example
```
docker run --name TeamFortress2 -d \
	-p 27015:27015 -p 27015:27015/udp \
	--env 'GAME_ID=232250' \
	--env 'GAME_NAME=tf' \
	--env 'GAME_PORT=27015' \
	--env 'GAME_PARAMS=-secure +maxplayers 32 +map de_dust2' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/teamfortress2:/serverdata/serverfiles \
	ich777/steamcmd:tf2
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.
