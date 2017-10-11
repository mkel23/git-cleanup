#!/bin/bash

# Use this to escape, rather than \e
esc=$(printf '\033')

arrow=$(echo -ne "${esc}[1;37m||>${esc}[0m ")

delete_branch()
{
    echo -n "${esc}[1;32m"
    git branch -D "$1"
    echo -n "${esc}[0m"
}

prompt_delete()
{
    read -rp "${arrow}${esc}[1;31mDelete branch $line? (Y/n)${esc}[0m " yn </dev/tty
    case $yn in
        [Yy]* ) delete_branch "$line"; echo; return;;
        [Nn]* ) echo -e "${esc}[1;34mSkipped $line${esc}[0m\\n"; return;;
    esac
}

prune_origin()
{
    echo -n "${esc}[1;32m"
    git remote prune origin
    echo -n "${esc}[0m"
}

prompt_prune()
{
    if [[ $(git remote prune --dry-run origin) ]]; then
        echo -n "${esc}[1;33m"
        git remote prune --dry-run origin
        echo -e "${esc}[0m"
        read -rp "${arrow}${esc}[1;31mPrune origin refs? (Y/n)${esc}[0m " yn </dev/tty
        case $yn in
            [Yy]* ) echo; prune_origin; echo; return;;
            [Nn]* ) echo -e "${esc}[1;34mSkipped pruning for origin${esc}[0m\\n"; return;;
        esac
    fi
}

loop_branches()
{
    git branch | while read -r line
    do
        if [[ $line == *"master"* || $line == *"*"* ]]; then
            continue
        fi
        prompt_delete "$line"
    done
}

loop_branches
prompt_prune
echo -e "${esc}[1;32mDONE.${esc}[0m"
