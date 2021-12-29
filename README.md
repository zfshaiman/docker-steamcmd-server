# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Wreckfest and run it.
Servername: 'Wreckfest Docker' Password: 'Docker'

**Update Notice:** Simply restart the container if a newer version of the game is available.

>**WEB CONSOLE:** You can connect to the Wreckfest console by opening your browser and go to HOSTIP:9028 (eg: 192.168.1.1:9028) or click on WebUI on the Docker page within Unraid.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to install a static or beta version of the game change the value to: '361580 -beta YOURBRANCH' (without quotes, replace YOURBRANCH with the branch or version you want to install). | 361580 |
| GAME_PARAMS | Enter your start up commands for the server if needed. | none |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | true |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |

## Run example
```
docker run --name Wreckfest -d \
	-p 33540:33540/udp -p 27015-27016:27015-27016/udp -p 9028:8080 \
	--env 'GAME_ID=361580' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/cstrikesource:/serverdata/serverfiles \
	ich777/steamcmd:wreckfest
```


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.
