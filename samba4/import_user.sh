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

log_file="/tmp/import_user_$(date +%d_%m_%s).out"
touch $log_file

OK=0
ERROR=0

while read line
do
  username=$(echo -e "$line" | cut -d';' -f1)
  name=$(echo -e "$line" | cut -d';' -f2)
  surname=$(echo -e "$line" | cut -d';' -f3)
  password=$(echo -e "$line" | cut -d';' -f4)
  ou=$(echo -e "$line" | cut -d';' -f5)
  email=$(echo -e "$line" | cut -d';' -f6)


  echo -e "\nImporting user: $username"
  echo -e "\nsamba-tool user create $username $password --userou=\"$ou\" --surname=\"$surname\" --given-name=\"$name\" --mail-address=$email" >> $log_file 2>&1
  samba-tool user create $username $password --userou="$ou" --surname="$surname" --given-name="$name" --mail-address=$email >> $log_file 2>&1
  if [[ $? == 0 ]]; then
    let OK++
      echo "Successfully imported."
  else
    let ERROR++
      echo "Import error."
  fi
done < $1


echo -e "\nSuccessfully imported: $OK"
echo "Import error: $ERROR"
echo -e "See result on: $log_file\n"
