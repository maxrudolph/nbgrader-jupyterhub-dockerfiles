#!/bin/bash
docker build -t g326-2017 . && \
docker run -p 443:443 --env-file env.secrets -d -t g326-2017 && \
docker ps
