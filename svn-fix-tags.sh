#!/usr/bin/env bash
#
# Converts the svn tag soup to something reasonable.

set -e

renameTag () {
  git tag -f $2 $1
  git tag -d $1
}

deleteTags () {
  git tag |grep -v ^2\.9 | grep RC
  cat <<EOM
2.1.7.patch8283
2.2.0.9025
2.2.0.9153
2.2.0.9278
2.3.3.10048
2.8.0.Beta1.prerelease
EOM
}  

for tag in $(git tag | grep ^R_); do 
  newtag=$(echo ${tag:2} |sed 's/_/./g')
  renameTag $tag $newtag
done

for tag in $(git tag |grep final$); do
  renameTag $tag ${tag:0:-6}
done

for tag in $(deleteTags); do
  git tag -d $tag
done

renameTag release-1_0_0-b5 1.0.0.b5
renameTag release-1_0_0-b6 1.0.0.b6
renameTag release-1_1_0-b0 1.1.0.b0
