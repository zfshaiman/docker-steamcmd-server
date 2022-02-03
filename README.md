# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install TeamFortress Classic and run it.

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | SteamID for server | 90 +app_set_config '90 mod tfc' |
| GAME_NAME | SRCDS gamename | tfc |
| GAME_PARAMS | Values to start the server | -secure +maxplayers 32 +map de_dust2 |
| GAME_MOD | Only required for Goldsource Games | 90 mod tfc |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| GAME_PORT | Port the server will be running on | 27015 |
| VALIDATE | Validates the game data | true |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |

## Run example
```
docker run --name TeamFortressClassic -d \
	-p 27015:27015 -p 27015:27015/udp \
	--env 'GAME_ID=90 +app_set_config '90 mod tfc'' \
	--env 'GAME_NAME=tfc' \
	--env 'GAME_MOD=90 mod tfc' \
	--env 'GAME_PORT=27015' \
	--env 'GAME_PARAMS=-secure +maxplayers 32 +map 2fort' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/teamfortressclassic:/serverdata/serverfiles \
	ich777/steamcmd:tf
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.
