#!/bin/bash

authorfile="$(dirname $0)/svn-authors.txt"
repourl="http://lampsvn.epfl.ch/svn-repos/scala/scala"
git2svn="/var/lib/gems/1.8/bin/svn2git"
curdir=$(pwd)

# First pull in the SVN commits without metadata
#$git2svn $repourl --authors $authorfile --trunk trunk --tags tags --branches branches 
git svn clone -s $repourl --authors-file=$authorfile scala-svn --no-metadata


pushd $curdir/scala-svn

# Now check out all remote branches so we have local copies.
git fetch . refs/remotes/*:refs/heads/*
# Remove rmeote branches
git branch -rd $(git branch -r | xargs)
# Remove trunk since master is a duplicate
git branch -D trunk

# Remove SVN stuff
git config --remove-section svn-remote.svn
rm -Rf .git/svn/

# Convert tag branches into git tags.
git for-each-ref --format='%(refname)' refs/heads/tags |
cut -d / -f 4 |
while read ref
do
  git tag "$ref" "refs/heads/tags/$ref";
  git branch -D "tags/$ref";
done

# Next filter the branches to remove binary artifacts.
#$curdir/filter-branch.sh
# Now clean up unreferenced commits.
#$curdir/clean-filtered-branch.sh

popd


# Now clone the repository somewhere else so we can push the cloned version to github.



