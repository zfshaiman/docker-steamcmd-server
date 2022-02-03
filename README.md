# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Unturned and run it.

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to install a static or beta version of the game change the value to: '1110390 -beta YOURBRANCH' (without quotes, replace YOURBRANCH with the branch or version you want to install). | 1110390 |
| GAME_PARAMS | Values to start the server | -pei -normal -nosync -pve |
| ROCKET_MOD | Set to 'true' (without quotes) to install Rocket Mod otherwise leave blank | empty |
| ROCKET_FORCE_UPDATE | If you want to force a update of Rocket Mod set to 'true' (without quotes) ATTENTION: All files in the 'Modules' & 'Scripts' folder will be overwritten backup the files bevor doing that! | empty |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | true |
| USERNAME | Leave blank for anonymous login | empty |
| PASSWRD | Leave blank for anonymous login | empty |

## Run example
```
docker run --name Unturned -d \
	-p 27015-27017:27015-27017 -p 27015-27017:27015-27017/udp \
	--env 'GAME_ID=1110390' \
	--env 'GAME_PARAMS=-pei -normal -nosync -pve' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/unturned:/serverdata/serverfiles \
	ich777/steamcmd:unturned
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.


## Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/