import os
#import system as sys
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
        subprocess.run(['useradd','-m','-s','/bin/bash',username])
        # check to see if user is in the nbgrader db.
        if( username in nbgrader_students ):
            print(username,"is already in the nbgrader database - skipping")
        else:
            print(username,"is not in the database. adding.")
            subprocess.run(['nbgrader','db','student','add',username,'--last-name=%s' % last,'--first-name=%s' % first])

#set -x
#userlist=$1
#UID_MIN=9000
#export UID_MIN=9000
#
#IFS="
#"
#for line in `cat $userlist`; do
#  test -z "$line" && continue
#  user=`echo $line | cut -f 1 -d' '`
#  first=`echo $line | cut -f 2 -d' '`
#  last=`echo $line | cut -f 3 -d' '`
#  uid=`echo $line | cut -f 4 -d' '`
#  echo "adding user $user"
#  useradd -m -s /bin/bash $user 
#  user_home=/home/$user
#  #sudo -u $user 'echo export PATH=\$PATH:${user_home}/.local/bin >> ${user_home}/.bashrc '
#sudo -u $user jupyter nbextension disable --user create_assignment/main
#  nbgrader db student add $user --last-name=$last --first-name=$first
#  cp -r /srv/ipython/examples /home/$user/examples
#  chown -R $user /home/$user/examples
#done

