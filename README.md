# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install ARK: Survival Evolved and run it.

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to install a static or beta version of the game change the value to: '376030 -beta YOURBRANCH' (without quotes, replace YOURBRANCH with the branch or version you want to install). | 376030 |
| MAP | Map name | TheIsland |
| SERVER_NAME | Leave empty if you want to use the settings from GameUserSettings.ini (this variable accepts no spaces) | empty |
| SRV_PWD | Leave empty if you want to use the settings from GameUserSettings.ini (this variable accepts no spaces) | empty |
| SRV_ADMIN_PWD | Leave empty if you want to use the settings from GameUserSettings.ini (this variable accepts no spaces) | empty |
| GAME_PARAMS | Enter your game parameters seperated with ? and start with a ? (don't put spaces in between eg: ?MaxPlayers=40?FastDecayUnsnappedCoreStructures=true) | empty |
| GAME_PARAMS_EXTRA | Values to start the server | -server -log |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | true |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |

## Run example
```
docker run --name ARKSurvivalEvolved -d \
	-p 7777-7778:7777-7778/udp -p 27015:27015/udp -p 27020:27020 \
	--env 'GAME_ID=376030' \
	--env 'MAP=TheIsland' \
	--env 'GAME_PARAMS_EXTRA=-server -log' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/ark-se:/serverdata/serverfiles \
	ich777/steamcmd:arkse
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

This Docker is forked from mattieserver, thank you for this wonderfull Docker.

### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/