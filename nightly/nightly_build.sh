#!/bin/bash
# Android Nightly Build Script

# Params
BUILD_DIR=~/MTMNightly
ANDROID_PROJECT_DIR=/Android
ANDROID_DIR="${BUILD_DIR}${ANDROID_PROJECT_DIR}"
REPO_EXISTS_FOLDER=/.git

SECURE_PROP_DIR=.


GIT_REPO=git://github.com/Mobile-Trail-Mapping/Android.git
# This is only the starting branch, all branches will be built
GIT_BRANCH=advanced-build

PATH_TO_ME=$PWD
DATE=`date "+%m-%d-%Y"`
git branch
# Pull the latest changes from the Android master branch
if [ -d "${BUILD_DIR}${REPO_EXISTS_FOLDER}" ]; then
  rm -rf "${BUILD_DIR}"
  mkdir "${BUILD_DIR}"
fi
  echo "Cloning Android branch ${GIT_BRANCH}..."
  git clone --branch $GIT_BRANCH $GIT_REPO "${BUILD_DIR}"
  cd $BUILD_DIR

  echo ""
  testvar=`git branch -r`
  echo "Printing Array:"
  echo ${testvar}
  echo "Retrieving Branches:"
  for name in ${testvar[@]}
  do
    acutal=(`echo $name | tr "/" " "`)
    branchname=${acutal[1]}
    if [ $branchname != "master" ] && [ $branchname != "HEAD" ]; then
      partsArray=( "${partsArray[*]}" "${branchname}" )
      echo "BRANCH: ${branchname}."
    fi
  done
  #echo "Final Array"
  #echo "${partsArray[@]}"
  cd $PATH_TO_ME
  partsArray=( "${partsArray[*]}" "master" )
  ls
  for build in ${partsArray[@]}
  do
    echo "*************************************"
    echo "* Cloning Android branch ${build}..."
    pwd
    echo "*************************************"
    if [ -d "${BUILD_DIR}${REPO_EXISTS_FOLDER}" ]; then
      echo "The build dir exists, refreshing..."
      ls
      rm -rf "${BUILD_DIR}"
      ls
      mkdir "${BUILD_DIR}"
      ls
    elif [ ! -d ${BUILD_DIR} ]; then
      mkdir "${BUILD_DIR}"
    fi
    git clone --branch $build $GIT_REPO "${BUILD_DIR}"
    echo "Git repo should have been cloned"
    cd $PATH_TO_ME
    echo "Adding secure.properties..."
    cp "${SECURE_PROP_DIR}/secure.properties" "${ANDROID_DIR}/secure.properties"

    echo "Adding brousalis.keystore..."
    cp "${SECURE_PROP_DIR}/brousalis.keystore" "${ANDROID_DIR}/brousalis.keystore"

    echo "Adding secret XML file..."
    cp "${SECURE_PROP_DIR}/secret.xml" "${ANDROID_DIR}/res/values/secret.xml"
    
    cd $ANDROID_DIR
    echo "******************************************"
    echo "* Attempting to build android project... *"
    echo "******************************************"
    android update project --path .
    ant release -s
    echo "*********************************************"
    echo "* Attempting to upload to nightly server... *"
    echo "*********************************************"
    scp "${ANDROID_DIR}/bin/ShowMap-release.apk" "brousali@brousalis.com:public_html/builds/android/MTMBeta_${DATE}_${build}.apk"
    FAIL=$?
    if [ ! $FAIL ]; then
      echo "***********************"
      echo "*       FAILURE       *"
      echo "* Build NOT Successful*"
      echo "***********************"
    else
      echo "***************"
      echo "*   SUCCESS   *"
      echo "***************"
    fi
    cd $PATH_TO_ME
    echo
    echo
    echo
    # read -p "Press any key to start backup…"
  done
  exit
  ls
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