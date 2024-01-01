[![Docker Pulls](https://img.shields.io/docker/pulls/shirom/ledfx.svg?style=for-the-badge&logo=github)](https://hub.docker.com/repository/docker/shirom/ledfx)

# LedFxDocker
A Docker Image for [LedFx](https://github.com/LedFx/LedFx.git). 

## Introduction
Compiling LedFx to run on different systems is difficult because of all the dependencies. It's especially difficult on a Raspberry Pi (building LedFx on ARM takes over 2 hours). This image has everything built for you, and it can get audio from a [Snapcast server](https://github.com/badaix/snapcast) or a [named pipe](https://www.linuxjournal.com/article/2156).

## Supported Architectures
This image supports `x86-64`, `arm` and `arm64`. Docker will automatically pull the appropriate version. 

## Tags 
Tag | Description 
--- | -------- 
`latest` | The master branch of LedFx. 
`frontend_beta` | The frontend_beta branch of LedFx. 

Feel free to open an issue if either of these is out of date

## Setup
### docker-compose.yml
```
version: '3'

services:
  ledfx:
    image: shirom/ledfx 
    container_name: ledfx
    environment: 
      - HOST=192.168.0.15
    ports:
      - 8888:8888
    volumes:
      - ~/ledfx-config:/app/ledfx-config
```

You can add support for network discovery by adding `network_mode: host`. See [use host networking](https://docs.docker.com/network/host/) for more information. Adding this can break compatibilty on Windows and Mac. 

### Volumes

Volume | Function 
--- | -------- 
`/app/ledfx-config` | This is where the LedFx configuration files are stored. Most people won't need to change anything here manually, so feel free to use a [named volume](https://stackoverflow.com/questions/43248988/how-do-named-volumes-work-in-docker).

### Environment Variables
Each variable corresponds to a different input method. One of the following variables must be set to send audio into the container (or you can set all of them). 

Variable | Function
--- | --------
`HOST` | This is the IP of the Snapcast server. Keep in mind that this IP is resolved from inside the container unless you use [host networking](https://docs.docker.com/network/host/). To refer to other docker containers in [bridge networking](https://docs.docker.com/network/bridge/) (the default for any two containers in the same compose file), just use the name of the container. To refer to `127.0.0.1` use `host.docker.internal` (compatibilty varies greatly between platforms and versions). 

### Snapcast

[Snapcast](https://github.com/badaix/snapcast) is a server for playing music synchronously to multiple devices. This image can act as a snapclient device and connect to a snapserver simply by setting the `HOST` environment variable, but you need to get audio into Snapcast too. 

Fundamentally, Snapcast's server gets its audio from a named pipe. This is where option two comes in; you can send audio directly into this image using its named pipe. Snapcast is useful if you have multiple speakers you want to connect to, you already have a snapserver, or you want to send audio from a separate device and have it play in both LedFx and over the system speaker out (`phone -> raspberry pi running Snapcast and LedFx -> speakers`). 

## Support Information
- Shell access while the container is running: `docker exec -it ledfx /bin/bash`
- Logs: `docker logs ledfx`

## Todo
- Check if a direct connection to the PulseAudio server works. [Example](https://github.com/balenablocks/audio#sendreceive-audio). 

## Building Locally

If you want to make local modifications to this image for development purposes or just to customize the logic:
```
git clone https://github.com/altesockensuppe/LedFxDocker.git
cd LedFxDocker
docker build -t shirom/ledfx .
```
To build for `x86-64` and `arm` use:

`docker buildx build --platform linux/amd64,linux/arm64,linux/arm/v7 --tag shirom/ledfx --output type=image,push=false .`

Keep in mind, this command takes over 2 hours to finish for `arm` because of the `aubio` installation.

If you're looking for ways to contribute, check the TODO or contribute to `examples/`. 
