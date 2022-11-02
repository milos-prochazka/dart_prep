#!/bin/sh
cd ..
CURRENTDATE=`date +"%Y-%m-%d %T"`
ARCHNAME=${PWD##*/}  
git archive -o "../$ARCHNAME $CURRENTDATE".zip HEAD

git stash push -m "git pull - $CURRENTDATE"
git checkout master
git fetch origin master
git rebase -i origin/master
git pull
