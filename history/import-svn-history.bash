#!/bin/bash
#Last pulled commit - r25928

svndir="/home/josh/projects/typesafe/svn/scala-svn"
gitdir="/home/josh/projects/typesafe/scala-git-for-paul"
svnauthorsfile="/home/josh/projects/typesafe/scala-repo-cleaner/svn-authors.txt"

getCommitAuthor() {
  local num=$1
  echo $(svn log -r $num | grep "$num" | awk '{ print $3 }')
}

portCommit() {
  local num=$1
  local next=$((num + 1))  # TODO - Is this ok?
  pushd $svndir > /dev/null
  local author=$(getCommitAuthor "$num")
  if [[ "$author" != "" ]]; then
    svn diff -r $num:$next > "/tmp/$num.diff"
    local gitauthorline=$(cat $svnauthorsfile | grep $author)
    echo ${gitauthorline##*= } > "/tmp/$num.author"
  fi
  popd > /dev/null
}

gitCommit() {
  local num=$1
  local author=$(cat /tmp/$num.author)
  local cdate=$(cat /tmp/$num.date)
  local msg=$(cat /tmp/$num.msg)
  local diff="/tmp/$num.patch"
  git --author $author --date $cdate -m 
  --author <author>     override author for commit
    --date <date>         override date for commit

}

portCommit "25259"
#svn diff -r 25928:25929 > small-svn.diff
#patch -p0 -i ~/fix_ugly_bug.diff
