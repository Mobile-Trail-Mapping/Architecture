#!/bin/bash
# Android Nightly Build Script

# Params
BUILD_DIR=~/MTMNightly
ANDROID_PROJECT_DIR=/Android
ANDROID_DIR="${BUILD_DIR}${ANDROID_PROJECT_DIR}"
REPO_EXISTS_FOLDER=/.git

SECURE_PROP_DIR=.

UPLOAD_PASSWORD_FILE=password.txt

GIT_REPO=git://github.com/Mobile-Trail-Mapping/Android.git
GIT_BRANCH=advanced-build

read -r PASSWORD < "password.txt"

PATH_TO_ME=$PWD
git branch
# Pull the latest changes from the Android master branch
if [ -d "${BUILD_DIR}${REPO_EXISTS_FOLDER}" ]; then
  rm -rf "${BUILD_DIR}"
  mkdir "${BUILD_DIR}"
fi
  echo "No Repo found, cloning..."
  git clone --branch $GIT_BRANCH $GIT_REPO "${BUILD_DIR}"
  cd $BUILD_DIR
#  read -r BRANCHES < temp-branches.txt
  #BRANCHES=( "fish" "dog" "bear" )
  echo ""
  declare -a parts
  git branch -r | while read line; do
      echo $line | tr "/" " "
      parts=(`echo $line | tr "/" " "`)
      echo ${parts[1]}
      echo ""
  done
  echo ""
  
  echo "Printing Array:"
  echo ${parts[*]}
  
  # for name in ${parts[@]}
  # do
  # echo "Value: ${name}"
  # done
  echo ""
  
  cd $PATH_TO_ME
  echo "Adding secure.properties"
  cp "${SECURE_PROP_DIR}/secure.properties" "${ANDROID_DIR}/secure.properties"
  
  echo "Adding brousalis.keystore"
  cp "${SECURE_PROP_DIR}/brousalis.keystore" "${ANDROID_DIR}/brousalis.keystore"
  
  echo "Adding secret XML file"
  cp "${SECURE_PROP_DIR}/secret.xml" "${ANDROID_DIR}/res/values/secret.xml"
  
  cd $BUILD_DIR

echo "Building Android"
cd $ANDROID_DIR
echo $ANDROID_DIR
#android update project --path .
#ant release
ls "${ANDROID_DIR}"
echo "Attempting to upload."
#scp "${ANDROID_DIR}/bin/ShowMap-release.apk" "fernferr@eric-stokes.com:public_html/mtm/nightly/builds/MTMBeta_Nightly.TEST.apk"
SUCCESS=$?
if [ $SUCCESS ]; then
    echo "Upload COMPLETE."
else
    echo "Could NOT upload."
fi