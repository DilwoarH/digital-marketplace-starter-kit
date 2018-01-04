#!/bin/bash
# RUN ALL: sh start.sh
# RUN Basic: sh start.sh basic

nginx="nginx"
action=($1 or "")

ps cax | grep $nginx > /dev/null

if [ $? -eq 0 ]; then
  echo "$nginx is running."
else
  echo "Attempting to start $nginx...."
  sudo nginx
  echo "$nginx now running."
fi

IFS=$'\r\n' GLOBIGNORE='*' command eval  'array=($(cat start_repo_list))'
counter=1

for i in "${array[@]}"
do
  cd $i && nohup make run-all &>/dev/null &
  echo "Starting ${i}..."
  if [ $counter -eq 1 ]
  then
    sleep 10
  elif [ $counter -eq 3 ] && [ $action = "basic" ]
  then
    break
  fi

  ((counter++))
  
done

echo "Applications should now be started..."
wait
