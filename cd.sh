#!/bin/sh
. colors

APPS="$1"

if [ -z "$APPS" ]; then
        echo -e $CL_RED"Please, Set APP where you are gonna moving"$CL_RST
        cd packages/apps
fi

if [ "$APPS" == "mmms" ] || [ "$APPS" == "MMS" ]; then
        echo -e "Moving to "$CL_YLW""packages/apps/Mms""$CL_RST
        cd packages/apps/Mms
fi

if [ "$APPS" == "settings" ] || [ "$APPS" == "Setings" ]
    then
        echo -e "Moving to "$CL_YLW""packages/apps/Settings""$CL_RST
        cd packages/apps/Settings
fi
