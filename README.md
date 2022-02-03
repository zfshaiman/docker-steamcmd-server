# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install ArmA III and run it. 

**Install Note:** You must provide a valid Steam username and password with Steam Guard disabled (the user dosen't have to have the game in the library).

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | SteamID for server | 233780 |
| GAME_PARAMS | Values to start the server | -config=server.cfg -mod= |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| GAME_PORT | Port the server will be running on | 2302 |
| VALIDATE | Validates the game data | blank |
| USERNAME | Leave blank for anonymous login | YOURSTEAMUSER |
| PASSWRD | Leave blank for anonymous login | YOURSTEAMPASSWORD |

## Run example
```
docker run --name ArmA3 -d \
	-p 2302:2302 -p 2302-2306:2302-2306/udp \
	--env 'GAME_ID=233780' \
	--env 'GAME_PORT=2302' \
	--env 'GAME_PARAMS=-config=server.cfg -mod=' \
	--env 'USERNAME=YOURSTEAMUSER' \
	--env 'PASSWRD=YOURSTEAMPASSWORD' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/arma3:/serverdata/serverfiles \
	--volume /path/to/arma3/profiles:/serverdata/.local/share \
	ich777/steamcmd:arma3
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.
