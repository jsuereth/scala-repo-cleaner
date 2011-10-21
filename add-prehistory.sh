#!/bin/bash

curdir=$(dirname $0)

# Now create new branch for starless scripts
git symbolic-ref HEAD refs/heads/starrless
rm .git/index
git clean -fdx

# Copy over first commit
cp -R $(dirname)/first-commit/* .

# Make first commit.
git add *
git commit -a -m "Binary file utilities"

# Grab Hash of early commit
monkeypatch=$(git log | grep "commit" | awk '{ print $2 }')

# Add grafts to the grafts file.
firstcommit=$(git log --reverse | head -n 1 | awk '{ print $2 }')

# Create a graft for this commit...
echo "$firstcommit $monkeypatch" >> .git/info/grafts
# REWRITE HISTORY
git filter-branch $monkeypatch..HEAD

# TODO, do we need to graft *every* branch?
