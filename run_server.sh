#!/bin/bash
set -x
VOLUME_BASE=$PWD/../docker-volumes
USER_HOMES=$VOLUME_BASE/home
COURSE_DIR=$VOLUME_BASE/GEL160-Fall2019

docker build -t gel160 . && \
docker run -v $USER_HOMES:/home \
	   -v $COURSE_DIR:/srv/nbgrader/GEL160-Fall2019 \
	   -v $VOLUME_BASE/exchange:/srv/nbgrader/exchange \
	   -v $VOLUME_BASE/data:/data \
	   --memory=64g --cpus=10 \
	   -p 443:443 --env-file env.secrets -i -t gel160  && \
docker ps
