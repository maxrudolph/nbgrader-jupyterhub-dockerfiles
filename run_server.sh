#!/bin/bash
set -x
VOLUME_BASE=$HOME/g326_2017/g326_2017_v1
USER_HOMES=$VOLUME_BASE/home
COURSE_DIR=$VOLUME_BASE/g326-2017

docker build -t g326-2017 . && \
   docker run -v $USER_HOMES:/home \
	   -v $COURSE_DIR:/srv/nbgrader/g326-2017 \
	   -v $VOLUME_BASE/exchange:/srv/nbgrader/exchange \
	   -p 443:443 --env-file env.secrets -i -t g326-2017  && \
docker ps
