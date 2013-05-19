#!/bin/sh
. colors

APPS="$1"

if [ -z "$APPS" ]; then
        echo -e $CL_RED"Please, Set APP where you are gonna moving"$CL_RST
        cd packages/apps 2>/dev/null
fi

if [ "$APPS" == "settings" ] || [ "$APPS" == "Setings" ] || [ "$APPS" == "Settings" ]
    then
        echo -e "Moving to "$CL_YLW""packages/apps/Settings""$CL_RST
        cd packages/apps/Settings 2>/dev/null
else
    if [ "$APPS" == "mms" ] || [ "$APPS" == "MMS" ]; then
        echo -e "Moving to "$CL_MAG""packages/apps/Mms""$CL_RST
        cd packages/apps/Mms 2>/dev/null
else
    if [ ! -d packages/apps/$1 ]
    then
        echo -e $CL_RED"There's no such a folder like "$1""$CL_RST
        echo -e $CL_RED"Set your destination again"$CL_RST
        cd packages/apps
else
        echo -e "Moving to "$CL_CYN""packages/apps/$1""$CL_RST
        cd packages/apps/$1 2>/dev/null
    fi
  fi
fi
