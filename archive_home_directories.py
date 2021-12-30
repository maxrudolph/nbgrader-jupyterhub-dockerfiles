#!/usr/bin/python3
import sys
arguments = len(sys.argv) - 1


print('Archiving all home directories');

#import os
import subprocess
#usertxt = os.system('nbgrader db student list')
thisout = subprocess.Popen(['nbgrader','db','student','list'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
stdout,stderr = thisout.communicate()
output = stdout.decode('utf-8').strip()
print(type(output))
print(output)
usertxt = output.split('\n')

subprocess.call('mkdir /home/archive',shell=True)
from datetime import datetime
now = datetime.now()
date_time=now.strftime('%Y-%m-%d')
#print(users)
#usertxt = out.split('\n');
for i in range(1,len(usertxt)):
    username = usertxt[i].split()[0]
    print(username)
    if True: # modify this to seleect a subset of users
        # make an incoming directory in this user's home directory
        print('Making archive for ',username)
        subprocess.call('zip -r /home/archive/'+username+'_'+date_time+'.zip ~'+username+'',shell=True)
        
