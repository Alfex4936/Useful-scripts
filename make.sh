#!/bin/bash
# Based on Bajee's buildscripts (It made life easier. :) )
# get current path
reldir=`dirname $0`
cd $reldir
DIR=`pwd`
DATE=$(date +%h-%d-%y)

# Colorize and add text parameters
red=$(tput setaf 1)             #  red
grn=$(tput setaf 2)             #  green
cya=$(tput setaf 6)             #  cyan
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) #  red
bldgrn=${txtbld}$(tput setaf 2) #  green
bldblu=${txtbld}$(tput setaf 4) #  blue
bldcya=${txtbld}$(tput setaf 6) #  cyan
txtrst=$(tput sgr0)             # Reset

# Command Center
DEVICE="$1"
SYNC="$2"
THREADS="$3"
CLEAN="$4"

# Initial Startup
res1=$(date +%s.%N)
echo -e "${cya}Start building MIRAGE ROM.${txtrst}";

# Unset CDPATH variable if set
if [ "$CDPATH" != "" ]
then
  unset CDPATH
fi

# Do ask 
if [ "THREADS" = "clean" ]
then
  THREADS="12"
fi

# Some jerks
if [ "$SYNC" == "repo" ]
then
  echo -e "${cya}Lul, Changing "repo" to "sync"!"
  $SYNC="sync"
fi

# Sync the latest MIRAGE Sources
echo -e ""
if [ "$SYNC" == "sync" ]
then
   if [ "$(which repo)" == "" ]
   then
      if [ -f ~/bin/repo ]
        then
        echo "Y U NO install repo?!"
        mkdir ~/bin
        export PATH=~/bin:$PATH
        curl https://dl-ssl.google.com/dl/googlesource/git-repo/repo > ~/bin/repo
        chmod a+x ~/bin/repo
      fi
   fi
   echo -e "${bldblu}Syncing MIRAGE SOURCE... ${txtrst}"
   repo sync -f -j"$THREADS"
   echo -e ""
fi

# Setup Environment (Cleaning)
if [ "$CLEAN" == "clean" ]
then
   echo -e "${bldblu}Cleaning out folder... ${txtrst}"
   make clobber;
else
  echo -e "${bldblu}Skipping cleaning out folder... ${txtrst}"
fi

# Setup Environment
echo -e "${bldblu}Setting up build enviroments... ${txtrst}"
. build/envsetup.sh

if [ "$DEVICE" == "all" ]
then
   echo -e ""
   echo -e "${bldblu}Start building MIRAGE ROM. ${txtrst}"
   echo -e "${bldblu}maguro ${txtrst}"
   lunch "mirage_maguro-userdebug"
   mka bacon TARGET_PRODUCT=mirage_maguro
   echo -e "${bldblu}toro ${txtrst}"
   lunch "mirage_toro-userdebug"
   mka bacon TARGET_PRODUCT=mirage_toro
   echo -e "${bldblu}crepo ${txtrst}"
   lunch "mirage_crespo-userdebug"
   mka bacon TARGET_PRODUCT=mirage_crespo
else
   # Lunch Device
   echo -e ""
   echo -e "${bldblu}Launching "$DEVICE"... ${txtrst}"
   lunch "mirage_$DEVICE-userdebug";

   echo -e ""
   echo -e "${bldblu}Start building MIRAGE ROM. ${txtrst}"

   # Start Building like a bau5
   mka bacon TARGET_PRODUCT=mirage_$DEVICE
   echo -e ""
fi

# Once building completed, bring in the Elapsed Time
res2=$(date +%s.%N)
echo "${bldgrn}Total time elapsed: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) minutes ($(echo "$res2 - $res1"|bc ) seconds) ${txtrst}"

