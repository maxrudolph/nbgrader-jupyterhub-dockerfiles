This repository contains files to run a jupyterhub server with nbgrader within a Docker container.

The repository is configured to serve jupyterhub at https://localhost/ which is an acceptable choice for development and testing. You would need to generate an ssl key pair for localhost (I used letesencrypt.org). To use this in a classroom setting, you would need to provide an appropriate ssl certificate. You may be able to do this yourself with letsencrypt.org, but on some campuses, the firewall will prevent you from being able to use letsencrypt and you'll have to have your sysadmin provide the ssl certificates.

To use this software, you neeed to:
1. populate the env.secrets file with GitHub OAuth credentials (see env.secrets.example) https://developer.github.com/apps/building-oauth-apps/creating-an-oauth-app/
2. populate the userlist (see userlist.example). The userlist is used to restrict access to only students/graders on the list.
3. edit jupyterhub_config.py to include correct usernames for grader and admin privliges.
4. edit nbgrader_config.py as appropriate to the host that the servers will run on. You will need to tell nbgrader where to look for assignment files and the exchange. See note below on nbgrader setup.
5. edit Dockerfile to point to your SSL public key and certificate for the machine on which the server will run. If you don't have one, you can generate a pair of keys at letsencrypt.org.
5. run ./run_server.sh

To see an example of some labs that we used in GEOL 326: Numerical Modeling of Earth Systems at Portland State University, you can check out the GitHub repository here: https://github.com/maxrudolph/g326

nbgrader setup:
I run this Docker container in a directory structure like so:

```bash
.
├── docker-volumes
│   ├── exchange
│   │
│   ├── g326-2017
│   │   ├── gradebook.db
│   │   ├── jupyterhub.sqlite
│   │   ├── jupyterhub_cookie_secret
│   │   ├── nbgrader_config.py
│   │   ├── return_feedback.py
│   │   ├── source
│   │   │   ├── header.ipynb
│   │   │   ├── lab0
│   │   │   │   ├── jupyter.png
│   │   │   │   └── problem1.ipynb
│   │   │   ├── lab1
│   │   │   │   ├── lab1.problem0.ipynb
│   │   │   │   ├── lab1.problem1.ipynb
│   │   │   │   ├── lab1.problem2.ipynb
│   │   │   │   ├── lab1.problem3.ipynb
│   │   │   │   └── river_centerline.txt
│   │   │   ├── lab2
│   │   │   │   └── lab2.problem0.ipynb
│   │   │   ├── lab3
│   │   │   │   └── lab3_problem0.ipynb
│   │   │   ├── lab4
│   │   │   │   ├── SK_Fig3-10.png
│   │   │   │   └── lab4_problem0.ipynb
│   │   │   ├── lab5
│   │   │   │   └── lab5_part5.ipynb
│   │   │   ├── lab6
│   │   │   │   ├── grid.png
│   │   │   │   └── lab6_2017.ipynb
│   │   │   ├── lab7
│   │   │   │   ├── Scarp_Cartoons.png
│   │   │   │   ├── lab7.ipynb
│   │   │   │   └── scarp_data.txt
│   │   │   ├── lab8
│   │   │   │   └── lab8_code.ipynb
│   │   │   ├── lab9
│   │   │   │   └── lab9.ipynb
│   │   │   ├── labfinal
│   │   │   │   ├── problem1.ipynb
│   │   │   │   └── problem2.ipynb
│   │   │   └── quiz2
│   │   │       └── quiz2.ipynb
│   └── home
│       ├── maxrudolph
│       │   └── lab0
│       │       ├── jupyter.png
│       │       └── problem1.ipynb
│       └── student
└── nbgrader-jupyterhub-dockerfiles
    ├── Dockerfile
    ├── README.md
    ├── addusers.py
    ├── cert.crt
    ├── env.secrets
    ├── env.secrets.template
    ├── jupyterhub_config.py
    ├── localhost.crt
    ├── localhost.key
    ├── private.key
    ├── run_jupyterhub.sh
    ├── run_server.sh
    ├── user_nbgrader_config.py
    ├── userlist
    └── userlist.example

38 directories, 70 files
```
