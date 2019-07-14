# docker-nuke

This is a Dockerfile that builds a container from CentOS 6.6 and The Foundry's Nuke.
This has been tested on MacOS Mojave.


### To run GUI enabled on MacOS

```
#!/bin/bash
brew cask install xquartz # Comment this line if you already have installed XQuartz
defaults write org.macosforge.xquartz.X11 app_to_run '' # suppress xterm terminal
open -a XQuartz
ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
display_number=`ps -ef | grep "Xquartz :\d" | grep -v xinit | awk '{ print $9; }'`
/opt/X11/bin/xhost + $ip
/usr/local/bin/docker rm nuke

/usr/local/bin/docker run -d --name nuke \
-e DISPLAY=$ip$display_number \
-v /tmp/.X11-unix:/tmp/.X11-unix \
-v ~/.gtkrc:/root/.gtkrc yourname/nuke-docker
```
-----
### To run GUI enabled on Windows 10
First you should install  [VcXsrv](https://sourceforge.net/projects/vcxsrv/) or [Xming](https://sourceforge.net/projects/xming/) to serve the X Window System.
Also you can use Chocolatey in the Powershell (the windows package manager) to download it:
`choco install vcxsrv`
then Open PowerShell (not cmd!) and type:

`set-variable -name DISPLAY -value YOUR-IP:0.0`

change YOUR-IP to your IP address. If you are not sure which address it is type:
`ipconfig`  and search for IPv4 Address.

The last step is:
```
docker run -ti --rm -e foundry_LICENSE=PORT@RLM_SERVER_IP_ADDRESS -e DISPLAY=$DISPLAY geoffroygivry/nuke-docker
```
You should be able to see your instance of nuke running in GUI mode.

For better performances, you will need to install the same Graphic Drivers from your host machine.

-----
### Building the nuke-docker image from the Dockerfile

```
mkdir nukeDocker 
cd nukeDocker
git clone https://github.com/geoffroygivry/nuke-docker.git
docker build -t yourname/nuke-docker .
```
-----
