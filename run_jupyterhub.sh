#!/bin/bash

python3 /srv/oauthenticator/addusers.py /srv/oauthenticator/userlist
jupyterhub -f /srv/jupyterhub_config/jupyterhub_config.py --debug
