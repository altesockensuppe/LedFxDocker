#!/bin/bash

# Start avahi daemon for WLED auto discovery
avahi-daemon --daemonize --no-drop-root

# https://superuser.com/questions/1539634/pulseaudio-daemon-wont-start-inside-docker
# Start the pulseaudio server
rm -rf /var/run/pulse /var/lib/pulse /root/.config/pulse
pulseaudio -D --verbose --exit-idle-time=-1 --system --disallow-exit

snapclient --host "$HOST" --daemon 1 --player pulse

mkdir /app/ledfx-config

mv -vn /app/config.yaml /app/ledfx-config/
mkdir /root/.ledfx
ledfx -c /app/ledfx-config 
