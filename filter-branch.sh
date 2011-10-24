#!/bin/bash
#
# TMPFS=/Volumes/MyRamDisk/tmpfs $0 ...

scriptdir=$(dirname $0)

tmpdir=${TMPFS:-.git-rewrite}

git filter-branch -d "$tmpdir" -f --tree-filter $scriptdir/tree-filter-no-jars --prune-empty --tag-name-filter cat -- --all
