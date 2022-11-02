cd ..

set archname=%cd%-%DATE%%TIME:~0,2%%TIME:~3,2%%TIME:~6,2%.zip
echo "%archname%"
git archive -o "%archname%" HEAD
