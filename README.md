# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install America's Army: Proving Grounds and run it.

Update Notice: Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to install a static or beta version of the game change the value to: '203300 -beta YOURBRANCH' (without quotes, replace YOURBRANCH with the branch or version you want to install). | 203300 |
| SRV_NAME | The server name | Army Docker |
| GAME_PARAMS | Values to start the server | -port=7778 -SAP=8778 -SQP=27015 -aauregion=1 -log=Server.log |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| GAME_PORT | Port the server will be running on | 27015 |
| VALIDATE | Validates the game data | true |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |

## Run example
```
docker run --name AmericasArmy-PG -d \
	-p 7778:7778/udp -p 8778:8778/udp -p 27015:27015/udp \
	--env 'GAME_ID=203300' \
	--env 'SRV_NAME=Army Docker' \
	--env 'GAME_PARAMS=-port=7778 -SAP=8778 -SQP=27015 -aauregion=1 -log=Server.log' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/americasarmy-pg:/serverdata/serverfiles \
	ich777/steamcmd:aaprovinggrounds
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

This Docker is forked from mattieserver, thank you for this wonderfull Docker.

### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/