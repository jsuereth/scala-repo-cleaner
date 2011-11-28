#!/usr/bin/env bash
#
# rewrite-commit-messages
# by paulp
# 

[[ $# -gt 0 ]] || {
  cat <<EOM
Usage: $0 [<rev-list options>...]

To rewrite all commits, give --all.
To rewrite a selection, give arguments for git rev-list, e.g. HEAD~100..HEAD
EOM
  exit 0
}

which par &>/dev/null || {
  echo "Cannot find required program `par`."
  echo "On OSX, brew install par."
  echo "Otherwise, http://www.nicemice.net/par/ "
  exit 1
}

git filter-branch --msg-filter $(dirname $0)/msg-filter-par \
  --tag-name-filter cat \
  -- \
  "$@"
