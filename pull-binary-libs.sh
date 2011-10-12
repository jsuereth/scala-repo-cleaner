#!/usr/bin/env bash
#
# Script to pull binary artifacts for scala from the remote repository.

. $(dirname $0)/binary-repo-lib.sh

# TODO - argument parsing...
pullJarFiles $(pwd)
