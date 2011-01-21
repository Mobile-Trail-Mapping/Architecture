#!/bin/bash
# Android Nightly Build Script

# Params
BUILD_DIR=~/MTMNightly
ANDROID_PROJECT_DIR=/Android
REPO_EXISTS_FOLDER=/.git

KEYSTORE_DIR=.
SECURE_PROP_DIR=.

GIT_REPO=git://github.com/Mobile-Trail-Mapping/Android.git
GIT_BRANCH=advanced-build

# Pull the latest changes from the Android master branch
if [ -d "${BUILD_DIR}${REPO_EXISTS_FOLDER}" ]; then
  echo "Git repo exists, updating"
  cd $BUILD_DIR
  git status
  git pull
else
  echo "No Repo found, cloning..."
  git clone --branch $GIT_BRANCH $GIT_REPO "${BUILD_DIR}"
  
  echo "Adding secure.properties"
  cp "${SECURE_PROP_DIR}/secure.properties" $BUILD_DIR
  
  echo "Adding brousalis.keystore"
  cp "${KEYSTORE_DIR}/brousalis.keystore" $BUILD_DIR
  
  cd $BUILD_DIR
fi

echo "Building Android"

ls "${PWD}${ANDROID_PROJECT_DIR}"