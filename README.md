# g326-2017
This repository contains files to run a jupyterhub server with nbgrader within a Docker container.
A typical use case would have the user:

1. populate the env.secrets file (see env.secrets.example)
2. populate the userlist
3. edit jupyterhub_config.py to include correct usernames for grader and admin privliges
4. edit nbgrader_config.py as appropriate to the host that the servers will run on.

