#!/bin/sh
git status
git add --all
read -p "Enter comment of the commit: " comment
git commit -m "${comment}"
unsetenv LD_LIBRARY_PATH
git push origin master
