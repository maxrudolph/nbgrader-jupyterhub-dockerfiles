#!/usr/bin/python3
import sys
arguments = len(sys.argv) - 1
assert(arguments == 1)
file_to_copy = sys.argv[1]

print('Distributing the file ',file_to_copy,' to students');

#import os
import subprocess
#usertxt = os.system('nbgrader db student list')
thisout = subprocess.Popen(['nbgrader','db','student','list'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
stdout,stderr = thisout.communicate()
output = stdout.decode('utf-8').strip()
print(type(output))
print(output)
usertxt = output.split('\n')

#print(users)
#usertxt = out.split('\n');
for i in range(1,len(usertxt)):
    username = usertxt[i].split()[0]
    print(username)
    if True: # modify this to seleect a subset of users
        # make an incoming directory in this user's home directory
        print('making incoming directory for ',username)
        subprocess.call('mkdir ~' +username+ '/incoming',shell=True)
        subprocess.call('chown ' + username + ' ~' +username+ '/incoming',shell=True)
        subprocess.call('chgrp ' + username + ' ~' +username+ '/incoming',shell=True)
        subprocess.call('cp ' + file_to_copy + ' ~' +username + '/incoming/',shell=True)
        subprocess.call('chown ' + username + ' ~' + username + '/incoming/' + file_to_copy,shell=True)
        subprocess.call('chgrp ' + username + ' ~' + username + '/incoming/' + file_to_copy,shell=True)
        
