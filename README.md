# docker-nuke

This is a Dockerfile that builds a container from CentOS 6.6 and The Foundry's Nuke.
This has been tested on MacOS Mojave.

### to build

```
    docker build -t yourname/nuke-docker .
```

### to run GUI enabled on MacOS.

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
