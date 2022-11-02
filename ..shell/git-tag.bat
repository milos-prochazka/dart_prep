cd ..
if .%1.==.. goto syntax


git tag %2
git push origin %2



goto end

:syntax
@echo Syntax: git-tag "tag"
:end
