#!/bin/bash
#sudo nginx

nginx="nginx"

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
  fi

  ((counter++))
  
done

echo "Applications should now be started..."
wait
