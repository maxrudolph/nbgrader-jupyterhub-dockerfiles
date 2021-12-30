#!/bin/bash
set -x
VOLUME_BASE=$PWD/../docker-volumes
USER_HOMES=$VOLUME_BASE/home
COURSE_DIR=$VOLUME_BASE/GEL240-Fall2021

docker build -t gel240 . && \
docker run -v $USER_HOMES:/home \
	   -v $COURSE_DIR:/srv/nbgrader/GEL240-Fall2021 \
	   -v $VOLUME_BASE/exchange:/srv/nbgrader/exchange \
	   -v $VOLUME_BASE/data:/data \
	   --memory=64g --cpus=10 \
	   -p 443:443 --env-file env.secrets -i -t gel240  && \
docker ps
