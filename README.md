# docker-webcams
Webcam capture &amp; exposure using RTMP

## Purpose
This container captures from home webcams and exposes as RTMP, HLS and DASH

## Configuration
Edit the file webcams.compose and replace:
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
