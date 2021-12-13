# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Project Zomboid and run it.

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | SteamID for server | 380870 |
| ADMIN_PWD | Password to become admin ingame | adminDocker |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | false |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |

## Run example
```
docker run --name ProjectZomboid -d \
	-p 16262-16326:16262-16326 -p 16261:16261/udp -p 27015:27015 \
	--env 'GAME_ID=380870' \
	--env 'ADMIN_PWD=adminDocker' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/projectzomboid:/serverdata/steamcmd \
	ich777/steamcmd:projectzomboid
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.
