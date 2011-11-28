#!/bin/bash

scriptdir=$(dirname $0)

if [[ "$1" != "" ]]; then
  git filter-branch -f --tree-filter $scriptdir/tree-filter-no-jars --prune-empty --tag-name-filter cat -- $1..HEAD
else
  git filter-branch -f --tree-filter $scriptdir/tree-filter-no-jars --prune-empty --tag-name-filter cat -- --all
fi
