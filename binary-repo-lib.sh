#!/usr/bin/env bash
#
# Library to push and pull binary artifacts from a remote repository using CURL.

# TODO - Set this if not on the environment.
if [[ "$tmpjardir" == "" ]]; then
  tmpjardir="/tmp/"
fi

remote_urlbase="http://typesafe.artifactoryonline.com/typesafe/starr-releases/org/scala-lang/bootstrap"
libraryJar="$(pwd)/lib/scala-library.jar"
desired_ext=".desired.sha1"

# Moves the jar file into a temp repository for later upload.
# Arugment 1 - The location to publish the file.
# Argument 2 - The file to publish.
# Argument 3 - The user to publish as.
# Argument 4 - The password for the user.
curlUpload() {
  local remote_location=$1
  local data=$2
  mkdir -p $(dirname $tmpjardir/bin-repo/$remote_location)
  echo "Copying $data to $tmpjardir/bin-repo/$remote_location"
  cp $data $tmpjardir/bin-repo/$remote_location
}


# Pushes a local JAR file to the remote repository and updates the .desired.sha1 file.
# Argument 1 - The JAR file to update.
# Argument 2 - The root directory of the project.
# Argument 3 - The user to use when publishing artifacts.
# Argument 4 - The password to use when publishing artifacts.
pushJarFile() {
  local jar=$1
  local basedir=$2
  local jar_dir=$(dirname $jar)
  local jar_name=${jar#$jar_dir/}
  pushd $jar_dir >/dev/null
  local jar_sha1=$(shasum -p $jar_name)
  local version=${jar_sha1% ?$jar_name}
  local remote_uri=${version}${jar#$basedir}
  curlUpload $remote_uri $jar_name
  echo "$jar_sha1" > "${jar_name}${desired_ext}"
  popd >/dev/null
  # TODO - Git remove jar and git add jar.desired.sha1
  # rm $jar
}

# Tests whether or not the .desired.sha1 hash matches a given file.
# Arugment 1 - The jar file to test validity.
# Returns: Empty string on failure, "OK" on success.
isJarFileValid() {
  local jar=$1
  if [[ ! -f $jar ]]; then
    echo ""
  else
    local jar_dir=$(dirname $jar)
    local jar_name=${jar#$jar_dir/}
    pushd $jar_dir >/dev/null
    local valid=$(shasum -p --check ${jar_name}${desired_ext} 2>/dev/null)
    echo "${valid#$jar_name: }"
    popd >/dev/null
  fi
}

# Pushes any jar file in the local repository for which the corresponding SHA1 hash is invalid or nonexistent.
# Argument 1 - The base directory of the project.
# Argument 2 - The user to use when pushing artifacts.
# Argument 3 - The password to use when pushing artifacts.
pushJarFiles() {
  local basedir=$1
  local user=$2
  local password=$3
  # TODO - ignore target/ and build/
  local jarFiles=$(find ${basedir} -name "*.jar")
  for jar in $jarFiles; do
    local valid=$(isJarFileValid $jar)
    if [[ "$valid" != "OK" ]]; then
      pushJarFile $jar $basedir
    fi
  done
  echo "Binary changes have been pushed.  You may now submit the new *${desired_ext} files to git."
}


