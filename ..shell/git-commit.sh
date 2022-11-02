#!/bin/sh

read -p "Komentar ke commitu:" comment

cd ..

if [[ "$comment" == "" ]] ; then
    read -t 10 -p "Komentar musi byt zadan" none
    exit 0
fi

dart-format ./ 2
dart-prep --enable-all ./
find ./ -name "*.bak" -type f -delete

git add --all
git commit --all -m "$comment"
