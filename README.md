# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install RUST and run it.

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Folder for SteamCMD | /serverdata/steamcmd |
| SERVER_DIR | Folder for gamefile | /serverdata/serverfiles |
| GAME_ID | The GAME_ID that the container downloads at startup. If you want to use a beta version of the game enter this: '258550 -beta staging' or '258550 -beta prerelease' (without quotes). | 258550 |
| GAME_PARAMS | Enter here your extra game startup parameters if needed starting with (eg: '+rcon.port 27016 +rcon.password YOURPASSWORD' don't forget to add also a new port mapping with container and host port set to the corresponding RCON port) | +server.maxplayers 10 |
| SERVER_NAME | Name of the Server goes here | RustDockerServer |
| SERVER_DISCRIPTION | Server Description goes here | Simple Unraid Rust Docker Server |
| OXIDE_MOD | Set to 'true' (without quotes) to enable Oxide Mod, otherwise leave empty (the container will check on every start/restart if there is a newer version available). | false |
| GAME_PORT | Game port on which the server is running (has to match the port mapping in your container). | 28015 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | false |
| USERNAME | Leave blank for anonymous login | blank |
| PASSWRD | Leave blank for anonymous login | blank |


## Run example
```
docker run --name RUST -d \
	-p 28015:28015/udp \
	--env 'GAME_ID=258550' \
	--env 'SERVER_NAME=RustDockerServer' \
	--env 'SERVER_DISCRIPTION=Simple Unraid Rust Docker Server' \
	--env 'GAME_PARAMS=+server.maxplayers 10' \
	--env 'GAME_PORT=28015' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/rust:/serverdata/serverfiles \
	ich777/steamcmd:rust
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!


This Docker is forked from mattieserver, thank you for this wonderfull Docker.

### Support Thread: https://forums.unraid.net/topic/79530-support-ich777-gameserver-dockers/