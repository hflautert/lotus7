#!/bin/bash
# import_user.sh
# hflautert@gmail.com
#
# ./import_user.sh users.csv
#
# users.csv syntax
# Username;Nanme;Surname;Password;Organizational Unit;Email
# john;John;Fourth;Passsw0rd;OU=Child,OU=Mother,OU=GrandMother;john@gmail.com
#
# Result - You must create OUs before import, the script just creates users.
# OU=GrandMother
#   OU=Mother
#      OU=Child
#        john

log_file=import_user.out
touch $log_file

while read line
do
  username=$(echo -e "$line" | cut -d';' -f1)
  name=$(echo -e "$line" | cut -d';' -f2)
  surname=$(echo -e "$line" | cut -d';' -f3)
  password=$(echo -e "$line" | cut -d';' -f4)
  ou=$(echo -e "$line" | cut -d';' -f5)
  email=$(echo -e "$line" | cut -d';' -f6)

  echo "Importing user:"
  echo "samba-tool user create $username $password --userou=\"$ou\" --surname=\"$surname\" --given-name=\"$name\" --mail-address=$email" >> $log_file
  samba-tool user create $username $password --userou="$ou" --surname="$surname" --given-name="$name" --mail-address=$email >> $log_file
done < $1
