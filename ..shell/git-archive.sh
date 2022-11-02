#!/bin/sh
cd ..
CURRENTDATE=`date +"%Y-%m-%d %T"`
ARCHNAME=${PWD##*/}  
git archive -o "../$ARCHNAME $CURRENTDATE".zip HEAD
