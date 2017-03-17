#!/bin/sh
set -x
userlist=$1

IFS="
"
for line in `cat $userlist`; do
  test -z "$line" && continue
  user=`echo $line | cut -f 1 -d' '`
  first=`echo $line | cut -f 2 -d' '`
  last=`echo $line | cut -f 3 -d' '`
  
  echo "adding user $user"
  useradd -m -s /bin/bash $user
  user_home=/home/$user
  sudo -u $user 'echo export PATH=\$PATH:${user_home}/.local/bin >> ${user_home}/.bashrc '
  sudo -u $user jupyter nbextension disable --user create_assignment/main
  nbgrader db student add $user --last-name=$last --first-name=$first
  #  cp -r /srv/ipython/examples /home/$user/examples
#  chown -R $user /home/$user/examples
done

