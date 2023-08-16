#!/bin/bash
python3 /srv/oauthenticator/addusers.py /srv/oauthenticator/userlist

# set up the formgrader
#setup_nbgrader grader-course101 course101_nbgrader_config.py
chmod 777 /var/log/grader/log
cp /srv/jupyterhub_config/grader_nbgrader_config.py ~grader/.jupyter/nbgrader_config.py
chown grader:grader ~grader/.jupyter/nbgrader_config.py
#create_course grader-course101 course101
touch /var/log/grader.log
chown grader /var/log/grader.log

# Enable extensions for grading account.
#sudo -u grader jupyter nbextension enable --user create_assignment/main
#sudo -u grader jupyter nbextension enable --user formgrader/main --section=tree
#sudo -u grader jupyter serverextension enable --user nbgrader.server_extensions.formgrader


jupyterhub -f /srv/jupyterhub_config/jupyterhub_config.py --debug
