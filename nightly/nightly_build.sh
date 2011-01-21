#!/bin/bash
# Android Nightly Build Script

# Params
BUILD_DIR=~/MTMNightly
ANDROID_PROJECT_DIR=/Android
ANDROID_DIR="${BUILD_DIR}${ANDROID_PROJECT_DIR}"
REPO_EXISTS_FOLDER=/.git

KEYSTORE_DIR=.
SECURE_PROP_DIR=.

GIT_REPO=git://github.com/Mobile-Trail-Mapping/Android.git
GIT_BRANCH=advanced-build

PATH_TO_ME=$PWD
# Pull the latest changes from the Android master branch
if [ -d "${BUILD_DIR}${REPO_EXISTS_FOLDER}" ]; then
  echo "Git repo exists, updating"
  cd $BUILD_DIR
  git status
  git pull
  cd $PATH_TO_ME
  echo "Adding secure.properties"
  cp "${SECURE_PROP_DIR}/secure.properties" "${ANDROID_DIR}/secure.properties"
  
  echo "Adding brousalis.keystore"
  cp "${KEYSTORE_DIR}/brousalis.keystore" "${ANDROID_DIR}/brousalis.keystore"
  
  echo "Adding secret XML file"
  cp "${KEYSTORE_DIR}/secret.xml" "${ANDROID_DIR}/res/values/secret.xml"
else
  echo "No Repo found, cloning..."
  git clone --branch $GIT_BRANCH $GIT_REPO "${BUILD_DIR}"
  
  cd $PATH_TO_ME
  
  echo "Adding secure.properties"
  cp "${SECURE_PROP_DIR}/secure.properties" "${ANDROID_DIR}/secure.properties"
  
  echo "Adding brousalis.keystore"
  cp "${KEYSTORE_DIR}/brousalis.keystore" "${ANDROID_DIR}/brousalis.keystore"
  
  echo "Adding secret XML file"
  cp "${KEYSTORE_DIR}/secret.xml" "${ANDROID_DIR}/res/values/secret.xml"
  
  cd $BUILD_DIR
fi

echo "Building Android"
cd $ANDROID_DIR
echo $ANDROID_DIR
android update project --path .
ant release