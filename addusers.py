# This script is run every time the Docker container starts. It adds unix users to the containerized system.
# It then checks to see if students are in the nbgrader database and if not adds them.
# Max Rudolph (maxrudolph@ucdavis.edu)

import os
import sys
import subprocess
print(len(sys.argv))
print(sys.argv[1])
userfile = open(sys.argv[1])
# get the nbgrader userlist
nbgrader_students = subprocess.run(['nbgrader','db','student','list'],stdout=subprocess.PIPE);

nbgrader_students_db = nbgrader_students.stdout.decode().split('\n')
del nbgrader_students_db[0]
nbgrader_students = []
for student in nbgrader_students_db:
    fields = student.split()
    if( len(fields) > 0):
        nbgrader_students.append( fields[0] )
print("nbgrader students:\n",nbgrader_students)


for user in userfile:
    fields = user.split()
    if( len(fields) > 0):
        username = fields[0]
        first = fields[1]
        last = fields[2]
        uid = fields[3]
        # add the system users
        subprocess.run(['useradd','-m','--uid',uid,'-s','/bin/bash',username])
        #subprocess.run(['mkdir','/home/%s/.jupyter' % username])
        #subprocess.run(['cp','/srv/jupyterhub_config/user_nbgrader_config.py','/home/%s/.jupyter/nbgrader_config.py' % username])
        # restrict permissions for students!
        subprocess.run(['chmod','700','/home/%s' % username])
        # check to see if user is in the nbgrader db.
        if( username in nbgrader_students ):
            print(username,"is already in the nbgrader database - skipping")
        else:
            print(username,"is not in the database. adding.")
            subprocess.run(['nbgrader','db','student','add',username,'--last-name=%s' % last,'--first-name=%s' % first])


