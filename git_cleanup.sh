#!/bin/bash

esc=$(printf '\033')

delete_branch()
{
    echo -n "${esc}[1;32m"
    git branch -D "$1"
    echo -n "${esc}[0m"
}

prompt_delete()
{
    read -rp "${esc}[1;31mDelete branch $line? (Y/n)${esc}[0m " yn </dev/tty
    case $yn in
        [Yy]* ) delete_branch "$line"; echo; return;;
        [Nn]* ) echo -e "${esc}[1;37mSkipped $line${esc}[0m\\n"; return;;
    esac
}

git branch | while read -r line
do
    if [[ $line == *"master"* || $line == *"*"* ]]; then
        continue
    fi
    prompt_delete "$line"
done
