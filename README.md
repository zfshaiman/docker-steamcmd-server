# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install ArmA III and Exile Mod and run it. 

**Install Note:** You must provide a valid Steam username and password with Steam Guard disabled (the user MUST have to have the game in the library, otherwise the download from Exile Mod will fail!).

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
| MARIA_DB_ROOT_PWD | Enter the preffered root password of the database. | ExileMod |
| WORKSHOP_MAN_INST | Please set to 'true' (without quotes) if you want to install the Workshopcontent for ExileMod manually since the account you specified above must have a valid game purchase for ArmA3 (you could also use one account to download the dedicated server files and another to install the Workshop files). A COMPLETE HOW TO WILL BE IN THE CONSOLE WARNING: Please let this variable set to 'true' if you initially set it to 'true'. | blank |
| VALIDATE | Validates the game data | blank |
| USERNAME | Leave blank for anonymous login | YOURSTEAMUSER |
| PASSWRD | Leave blank for anonymous login | YOURSTEAMPASSWORD |

## Run example
```
docker run --name ArmA3ExileMod -d \
	-p 2302:2302 -p 2302-2306:2302-2306/udp \
	--env 'GAME_ID=233780' \
	--env 'GAME_PORT=2302' \
	--env 'GAME_PARAMS=-config=server.cfg -mod=' \
	--env 'USERNAME=YOURSTEAMUSER' \
	--env 'PASSWRD=YOURSTEAMPASSWORD' \
	--env 'MARIA_DB_ROOT_PWD=ExileMod' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/arma3exilemod/gamefiles:/serverdata/serverfiles \
	--volume /path/to/arma3exilemod/profiles:/serverdata/.local/share \
	ich777/steamcmd:arma3exilemod
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.
