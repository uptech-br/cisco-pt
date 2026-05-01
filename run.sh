#!/bin/bash

docker container run \
    -d \
    --memory=8G \
    --cpus=4 \
    --privileged \
    --restart=unless-stopped \
    --device=/dev/fuse \
    --add-host www.cisco.com:127.0.0.1 \
    --add-host cisco.com:127.0.0.1 \
    --mount source=cisco-pt,target=/backup \
    -p 127.0.0.1:6901:6901 \
    -e VNC_PW=uptech \
    cisco-pt
