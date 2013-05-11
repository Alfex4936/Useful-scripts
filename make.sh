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
echo -e "${cya}MIRAGE 롬 빌드를 시작 합니다.${txtrst}";

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
   echo -e "${bldblu}최신 SLIM 롬 소스와 MIRAGE 소스 동기화 중... ${txtrst}"
   repo sync -f -j"$THREADS"
   echo -e ""
fi

# Setup Environment (Cleaning)
if [ "$CLEAN" == "clean" ]
then
   echo -e "${bldblu}out 폴더 청소 중... ${txtrst}"
   make clobber;
else
  echo -e "${bldblu}out 폴더 청소 건너뛰는 중... ${txtrst}"
fi

# Setup Environment
echo -e "${bldblu}빌드환경 갖추는 중... ${txtrst}"
. build/envsetup.sh

if [ "$DEVICE" == "all" ]
then
   echo -e ""
   echo -e "${bldblu}MIRAGE 롬 빌드를 시작 합니다. ${txtrst}"
   echo -e "${bldblu}Maguro ${txtrst}"
   lunch "mirage_maguro-userdebug"
   make -j"$THREADS" otapackage
   echo -e "${bldblu}toro ${txtrst}"
   lunch "mirage_toro-userdebug"
   make -j"$THREADS" otapackage
else
   # Lunch Device
   echo -e ""
   echo -e "${bldblu}"$DEVICE" 실행 중... ${txtrst}"
   lunch "mirage_$DEVICE-userdebug";

   echo -e ""
   echo -e "${bldblu}MIRAGE 롬 빌드 시작 합니다. ${txtrst}"

   # Start Building like a bau5
   mka bacon TARGET_TOOLS_PREFIX=`pwd`/android-toolchain-eabi/bin/arm-linux-androideabi- TARGET_PRODUCT=mirage_$DEVICE
   echo -e ""
fi

# Once building completed, bring in the Elapsed Time
res2=$(date +%s.%N)
echo "${bldgrn}총 걸린 시간: ${txtrst}${grn}$(echo "($res2 - $res1) / 60"|bc ) 분 ($(echo "$res2 - $res1"|bc ) 초) ${txtrst}"

