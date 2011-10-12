#!/bin/bash

scriptdir=$(dirname $0)

git filter-branch -f --tree-filter $scriptdir/tree-filter-no-jars --prune-empty --tag-name-filter cat -- --all
