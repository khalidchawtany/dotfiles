#!/bin/bash
# reset the current repository
# WF 2012-10-15
# AT 2012-11-09
# see http://stackoverflow.com/questions/1628088/how-to-reset-my-local-repository-to-be-just-like-the-remote-repository-head
timestamp=`date "+%Y-%m-%d-%H_%M_%S"`
branchname=`git rev-parse --symbolic-full-name --abbrev-ref HEAD`
read -p "Rest branch $branchname to origin (y/n)? "
[ "$REPLY" != "y" ] || 
echo "about to auto-commit any changes"
git commit -a -m "auto commit at $timestamp"
if [ $? -eq 0 ]
then
  echo "Creating backup auto-save branch: auto-save-$branchname-at-$timestamp"
  git branch "auto-save-$branchname-at-$timestamp" 
fi
echo "now resetting to origin/$branchname"
git fetch origin
git reset --hard origin/$branchname
