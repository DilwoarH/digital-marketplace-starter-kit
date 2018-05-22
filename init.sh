#!/bin/bash
github_ssh="git@github.com:alphagov/"
IFS=$'\r\n' GLOBIGNORE='*' command eval  'array=($(cat clone_repo_list))'

echo "======================CLONING ALL REPOS======================"

for i in "${array[@]}"
do
  git clone "$github_ssh$i.git"
done

echo "======================INITIALISING REPOS======================"
sudo easy_install virtualenv

for i in "${array[@]}"
do
  cd $i && make requirements && npm install
  cd ..
done