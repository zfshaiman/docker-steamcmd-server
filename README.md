# SteamCMD in Docker optimized for Unraid
This Docker will download and install SteamCMD. It will also install Survive The Nights and run it.

**Update Notice:** Simply restart the container if a newer version of the game is available.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| STEAMCMD_DIR | Can be excluded. Maps Steamcmd itself to a real folder on the host filesystem. The benefit of doing this is that if you run multiple containers from this image, or others built from different branches in the repository, you can map them all to this folder and only have one copy of Steamcmd rather than tens, hundreds, or even thousands of copies, between all of your containers, needlessly wasting space. | /serverdata/steamcmd |
| SERVER_DIR | Should **not** be excluded, but can be. This maps the server files that store your server information. If your container is removed, the server files will be preserved to whatever path you /path/to/host/ on the host machine so you don't lose your world. **If you restart your container, and your world is gone because you excluded this, no one here can help you recover your data.** | /serverdata/serverfiles |
| GAME_ID | Set the AppID that Steamcmd will use to install/update/validate the server files. | 1502300 |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| VALIDATE | Validates the game data | false |

***ATTENTION: You have to disable Steam Guard for games that require authentication, Steam recommends to create a seperate account for dedicated servers***

## Run example
```
docker run --name SurviveTheNights -d \
	--restart unless-stopped \
	-p 7950-7951:7950-7951/udp \
	--env 'GAME_ID=1502300' \
	--env 'UID=99' \
	--env 'GID=100' \
	--volume /path/to/steamcmd:/serverdata/steamcmd \
	--volume /path/to/survivethenights:/serverdata/serverfiles \
	ich777/steamcmd:stn
```

This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it! This specific branch for Survive The Nights has also been tested successfully in an Archlinux environment (thank you to [SteindelSE](https://github.com/SteindelSE) for the PR and confirmation).

This Docker is forked from mattieserver, thank you for this wonderfull Docker.