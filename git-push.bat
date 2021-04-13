if .%1.==.. goto syntax
dart-prep --enable-all .\
git add --all
git commit --all -m %1
git push --all
git gc
git gc --aggressive
git prune
goto end
:syntax
@echo Syntax: git-push "message"
:end
