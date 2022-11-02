cd ..
rem rd .dart_tool /q /s
rem del .packages
rd build /q /s
rd .dart_tool /q /s
rd windows\flutter\ephemeral /q /s
del /q /f /s *.bak
del /q /f /s *.tmp
del /q /f /s *.suo
del /q /f /s *.user
del /q /f /s *.userosscache
del /q /f /s *.sln.docstates
del /q /f /s *.cache
del /q /f /s *.exe
del /q /f /s *.aot
del /q /f /s *.jit
del /q /f /s *.kernel
git gc
git gc --aggressive
git prune



