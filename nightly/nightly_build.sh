#!/bin/bash
# Android Nightly Build Script

# Params
BUILD_DIR=~/MTMNightly/
REPO_EXISTS_FOLDER=.git/
GIT_REPO=git://github.com/Mobile-Trail-Mapping/Android.git

# Pull the latest changes from the Android master branch
if [ -d "${BUILD_DIR}${REPO_EXISTS_FOLDER}" ]; then
  echo "Git repo exists, updating"
  cd $BUILD_DIR
  git status
  git pull
else
  echo "No Repo found, cloning..."
  git clone $GIT_REPO "${BUILD_DIR}"
fi
