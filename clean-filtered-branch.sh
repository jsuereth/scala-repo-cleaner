#!/bin/bash

# Cleans up git filter-branch mess.
# rm -rf .git/refs/original/ &&

git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d &&
git reflog expire --expire=now --all &&
git gc --prune=now &&
git gc --aggressive --prune=now
