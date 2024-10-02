#!/usr/bin/env bash -l
# ####### Mikes Ultimate Mac OS Developer Disk Cleanup ######
# @author Mike Cunneen (https://github.com/cunneen)
# @license MIT
# @version 1.0.0
#
# ==== WARNING: THIS MIGHT REMOVE STUFF YOU ACTUALLY WANT TO KEEP ===
# This script will clean up your Mac's disk space. Aggressively.
# Currently it searches for (and cleans) the following items:
# - MacOS Trash
# - MacOS (User) Library Caches
# - meteor package cache (shared between projects)
# - meteor projects in your development base directory
# - node_modules folders in your development base directory
# - npm cache
# - yarn cache
# - bun cache
# - Xcode DerivedData
# - Xcode DeviceLogs
# - iOS device support files
# - Xcode caches
# - gradle caches
# - android build folders
# - ruby gems
# - docker containers, images, volumes, etc
# - Android SDK packages
# - Android AVDs
# - Homebrew caches

# ==== CONFIGURATION DEFAULTS - change as needed ====
CONFIGFILE="${HOME}/.config/mikes-macos-disk-cleanup.env" # you'll be prompted to create this if it doesn't exist

# set the development base directory (within which we'll search for development projects)
DEVELOPMENT_BASE_DIR="${HOME}/Development" # set this to your development base directory

# ---- Read saved configuration, fall back to prompt user for values
if [ ${INITIALISED:-0} -ne 1 ]; then
  # if ${CONFIGFILE} exists then source it
  if [ -f ${CONFIGFILE} ]; then
    echo "found ${CONFIGFILE}"
    source ${CONFIGFILE}
  else
    echo "==== WARNING: THIS MIGHT REMOVE STUFF YOU ACTUALLY WANT TO KEEP ==="
    echo "= This script will clean up your Mac's disk space. Aggressively.  ="
    echo "= Back up your stuff first!                                       ="
    echo "==================================================================="

    read -p "Do you understand and accept the risk? [type 'yes']: " ACKNOWLEDGEMENT
    if [ "${ACKNOWLEDGEMENT}" != "yes" ]; then
      echo "Exiting..."
      exit 1
    fi

    echo "=== CONFIGURATION ==="
    read -p "Enter your development base directory [defaults to $DEVELOPMENT_BASE_DIR]: " DEVELOPMENT_BASE_DIR
    # fall back to defaults where no values are provided (e.g. user just pressed enter)
    DEVELOPMENT_BASE_DIR=${DEVELOPMENT_BASE_DIR:-"${HOME}/Development"}
    # ask the user if they would like to save the configuration

    read -p "Save configuration? [y/n]" SHOULD_SAVE_CONFIG
    SHOULD_SAVE_CONFIG=${SHOULD_SAVE_CONFIG:-"y"}
    if [ "${SHOULD_SAVE_CONFIG}" == "y" ]; then
      # save the configuration
      echo "Saving configuration..."
      CONFIGDIR=$(dirname ${CONFIGFILE})
      if [ ! -d ${CONFIGDIR} ]; then
        mkdir -p ${CONFIGDIR}
      fi
      printf "DEVELOPMENT_BASE_DIR=${DEVELOPMENT_BASE_DIR}\n" >${CONFIGFILE}
      echo "Configuration saved to ${CONFIGFILE}"
    else
      echo "Not saving configuration..."
    fi
  fi

  echo "Using development base directory: ${DEVELOPMENT_BASE_DIR}"
  if [ ! -d ${DEVELOPMENT_BASE_DIR} ]; then
    echo "ERROR: ${DEVELOPMENT_BASE_DIR} does not exist"
    exit 1
  fi
fi

INITIALISED=1 # set to 1 so that the script will not prompt again (only really makes sense if shared by multiple scripts)

# ==== END OF CONFIGURATION ====
# get the full path for the current dir
DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# ===== Error handling =======
# set -e: exit on error
set -e

# invoke the catch() function whenever an error occurs
trap 'catch $? $LINENO' EXIT

# catch() function just prints an error message (before exit)
catch() {
  if [ "$1" != "0" ]; then
    # error handling goes here
    echo "Error $1 occurred on $2" >&2
  fi
}

######### MAIN PROGRAM #########
echo "======= Starting Mac OS Disk Cleanup ======"
HINTS_UPON_FINISH="" # we'll progressively add info to this and output it to the user upon completion
# print the available space (for later comparison)
INITIALSPACE=$(
  df -h "${HOME}" |
    tail -1 |
    awk '{\
      mp=$1; sz=$2; used=$3; avail=$4; cpc=$5; mp=$9; \
      printf("%s available (%s used) ", avail, used);\
    }'
)
echo "DISK USAGE BEFORE CLEANUP: ${INITIALSPACE}"

# # remove everything in ~/Library/Caches
# source "${DIR}/modules/library-caches.sh"
# libraryCaches

# # remove everything from Trash - this sometimes prompts for confirmation
# source "${DIR}/modules/trash.sh"
# trash

# # meteor
# source "${DIR}/modules/meteor-builds-and-packages.sh"
# meteorBuildsAndPackages

# # npm cache
# source "${DIR}/modules/npm-cache.sh"
# npmCache

# # yarn cache
# source "${DIR}/modules/yarn-cache.sh"
# yarnCache

# # bun cache
# source "${DIR}/modules/bun-cache.sh"
# bunCache

# ### XCode ###
source "${DIR}/modules/xcode-artifacts.sh"
xcodeArtifacts

# Clear shared gradle caches
source "${DIR}/modules/gradle-shared.sh"
gradleShared

# node_modules folders
source "${DIR}/modules/node-modules.sh"
nodeModules

# ruby gems
source "${DIR}/modules/ruby-gems.sh"
rubyGems

# Docker
source "${DIR}/modules/docker-files.sh"
dockerFiles

# Android projects - remove build folders
source "${DIR}/modules/android-build-folders.sh"
androidBuildFolders

# Android SDKs
source "${DIR}/modules/android-sdk.sh"
androidSDK

# Android AVDs
source "${DIR}/modules/android-avd.sh"
androidAVD

# Homebrew Caches
source "${DIR}/modules/homebrew-caches.sh"
homebrewCaches

# get the disk usage now that we've run the cleanup
FINALSPACE=$(
  df -h "${HOME}" |
    tail -1 |
    awk '{\
      mp=$1; sz=$2; used=$3; avail=$4; cpc=$5; mp=$9; \
      printf("%s available (%s used) ", avail, used);\
    }'
)

echo "=== FINISHED! ==="

echo "DISK USAGE BEFORE CLEANUP: ${INITIALSPACE}"
echo "DISK USAGE AFTER CLEANUP: ${FINALSPACE}"
echo "${HINTS_UPON_FINISH}"
