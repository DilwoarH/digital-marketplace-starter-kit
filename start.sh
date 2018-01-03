#!/bin/bash
#sudo nginx

action=($1 or "")

IFS=$'\r\n' GLOBIGNORE='*' command eval  'array=($(cat start_repo_list))'
counter=1

for i in "${array[@]}"
do
  if [ $action = "init" ]
  then
    cd $i && make requirements && npm install
    cd ..
  else
    cd $i && nohup make run-all &>/dev/null &
    echo "Starting ${i}..."
    if [ $counter -eq 1 ]
    then
      sleep 10
    fi
  fi

  ((counter++))
  
done

if [ $action != "init" ]
then
  echo "Applications should now be started..."
  wait
fi