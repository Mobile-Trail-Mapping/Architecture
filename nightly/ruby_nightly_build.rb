#!/usr/bin/env ruby

BUILD_DIR = "~/MTMNightly"
ANDROID_PROJECT_DIR = "/Android"
ANDROID_DIR = BUILD_DIR + ANDROID_PROJECT_DIR

REPO_EXISTS_FOLDER = "/.git"

SECURE_PROP_DIR = "."

GIT_REPO = "git://github.com/Mobile-Trail-Mapping/Android.git"
GIT_BRANCH = "advanced-build"

PATH_TO_ME = File.dirname(__FILE__)
puts "Fish"
puts PATH_TO_ME
puts Dir.pwd
if File.directory?( + REPO_EXISTS_FOLDER)
  exec 'rm -rf ' + BUILD_DIR
  Dir.mkdir(BUILD_DIR)
  puts "Directory created"
end
puts BUILD_DIR + REPO_EXISTS_FOLDER