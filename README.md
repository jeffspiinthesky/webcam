# docker-webcams
Webcam capture &amp; exposure using RTMP

## Purpose
This container captures from home webcams and exposes as RTMP, HLS and DASH

## Install Docker and Docker-compose
```
sudo apt install docker docker.io docker-compose
sudo usermod -aG docker pi
```
Then log out and back in again.

## Build
You can build the container as follows. You can replace the value of the '-t' option with any Docker-compatible tag you like
```
docker build -t jeffspiinthesky/webcam:0.0.1 -f Dockerfile .
```

## Configuration
Edit the file webcams.compose and replace:
* DOCKER_TAG with the tag you defined for your Docker container
* MY_USER with the username for your webcam
* MY_PASSWORD with the password for your webcam
* LORES_URI with the URI of the low-res stream for your webcam (or the hi-res one if only one is provided) e.g. 1.2.3.4/12
* HIRES_URI with the URL of the high-res stream for your webcam e.g. 1.2.3.4/11

## Run
```
docker-compose -f webcams.compose up -d
```

## Stop
``` 
docker-compose -f webcams.compose down
```
