cd ..

set archname=%cd%-%DATE%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.zip
echo "%archname%"
git archive -o "%archname%" HEAD

git stash push -m "git pull - %date% %time%"
git checkout master
git fetch origin master
git rebase -i origin/master
git pull
