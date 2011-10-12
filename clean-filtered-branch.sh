#!/bin/bash

# Cleans up git filter-branch mess.
rm -rf .git/refs/original/ &&
git reflog expire --expire=now --all &&
git gc --prune=now &&
git gc --aggressive --prune=now
