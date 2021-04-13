dart-prep --enable-all .\
git add --all
git commit --all -m %1
git push --all
git gc
git gc --aggressive
git prune
