# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Valheim and run it.

Update Notice: Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. | 896660 |
| SRV_NAME | Name of the Server | Valheim Docker |
| WORLD_NAME | Name of the Server World | Dedicated |
| SRV_PWD | Server Password - **ATTENTION:** the minimum length is 6 characters! | Docker |
| PUBLIC | List Server as Public (set to '0' to disable or set to '1' to enable). | 1 |
| ENABLE_VALHEIMPLUS | If you want to enable ValheimPlus set this variable to 'true' (without quotes). For more help please refer to this site: [Click](https://github.com/nxPublic/ValheimPlus) | false |
| ENABLE_BEPINEX | If you want to enable BepInEx for Valheim set this variable to 'true' (without quotes). For more help please refer to this site: [Click](https://valheim.thunderstore.io/package/denikson/BepInExPack_Valheim/) | false |
| BACKUP_FILES | Set this value to 'true' to enable the automated backup function from the container, you find the Backups in '.../valheim/Backups/'. Set to 'false' to disable the backup function. | true |
| BACKUP_INTERVAL | The backup interval in minutes (set to 62 minutes because the game automatically saves the database every 30 minutes) **ATTENTION:** The first backup will be triggered after the set interval in this variable after the start/restart of the container). | 62 |
| BACKUP_TO_KEEP | Number of backups to keep (by default set to 24 to keep the last backups of the last 24 hours). | 24 |
| UPDATE_CHECK | If set to 'true' the container will automatically check every 60 minuts if there is an update available and restart the container if a update is found (please keep in mind if you enable the auto update function the container will automatically restart if a newer version is found, set to 'false' to disable the update check). | false |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| GAME_PORT | Only change if you know what you are doing (intital GAME_PORT - Dont forget to create create a new UDP port mapping with the corresponding port range and delete the default port range - GAME_PORT +2) | 2456 |
| VALIDATE | Validates the game data | true |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |


## Run example
```
docker run --name Valheim -d \
	-p 2456-2458:2456-2458/udp \
	--env 'GAME_ID=896660' \
	--env 'SRV_NAME=Valheim Docker' \
	--env 'WORLD_NAME=Dedicated' \
	--env 'SRV_PWD=Docker' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/valheim:/serverdata/serverfiles \
	ich777/steamcmd:valheim
```


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.
