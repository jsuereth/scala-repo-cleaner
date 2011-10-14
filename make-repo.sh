#!/bin/bash

authorfile="$(dirname $0)/svn-authors.txt"
repourl="http://lampsvn.epfl.ch/svn-repos/scala/scala"
git2svn="/var/lib/gems/1.8/bin/svn2git"
curdir=$(pwd)

# First pull in the SVN commits without metadata
#$git2svn $repourl --authors $authorfile --trunk trunk --tags tags --branches branches 
git svn clone -s $repourl --authors-file=$authorfile scala-svn --no-metadata

# Next clone the repo so that the SVN junk is dropped.
git clone scala-svn scala-git


pushd $curdir/scala-git

# Next filter the branches to remove binary artifacts.
#$curdir/filter-branch.sh
# Now clean up unreferenced commits.
#$curdir/clean-filtered-branch.sh

popd


