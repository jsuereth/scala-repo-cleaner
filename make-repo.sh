#!/bin/bash

authorfile="$(dirname $0)/svn-authors.txt"
repourl="http://lampsvn.epfl.ch/svn-repos/scala/scala"
git2svn="/var/lib/gems/1.8/bin/svn2git"

#$git2svn $repourl --authors $authorfile --trunk trunk --tags tags --branches branches 
git svn clone -s $repourl --authors-file=$authorfile scala-svn --no-metadata
