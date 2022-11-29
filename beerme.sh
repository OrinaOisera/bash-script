#!/usr/bin/bash

echo "my firsh bash script"

GREET="howdy Partner"
echo $GREET

getent passwd | awk -F: '{print $1 ":" $6}'

WATU=$(getent passwd | awk -F: '{print $1 ":" $6}')

echo $WATU

echo   -n   $WATU | md5sum | awk '{print $1}'

echo "creating current_users.txt and user_changes.txt"
touch /var/log/current_users.txt /var/log/user_changes.txt

md5_users="$(md5sum "$WATU" | cut -d' ' -f1)"           #Storing the md5 hash into a variable md5_users
if [ -s /var/log/current_users.txt ]                                   #If current_users.txt is not empty,
then
    current_users_txt_hash=`cat /var/log/current_users.txt`            #collect it's content.
    if [ "$md5_users" == "$current_users_txt_hash" ]                   #if the linux users hash match the old one, fine,
    then
    echo "No changes in the MD5 hash detected"
else                                                               #otherwise store the new hash into current_users.txt
  echo "$md5_users" > "/var/log/current_users.txt"
  echo "A change occured in the MD5 hash"
  now=$(date +"%m_%d_%Y_%T")                                         #creating a user_changes.txt file that logs the changES made
  echo "$now changes occured" > "/var/log/user_changes.txt"
  fi
else
    echo "Storing the MD5 hash into the filename.."                    #store the linux users hash into the current_users.txt (first script launch)
    echo "$md5_users" > "/var/log/current_users.txt"
fi

#References :  https://askubuntu.com/questions/53846/how-to-get-the-md5-hash-of-a-string-directly-in-the-terminal , used vcrotb gentrator: https://crontab.guru/