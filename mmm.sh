#!/bin/sh

# Include colors
. colors

echo ""
echo -e "Compiling "$CL_YLW"$1"$CL_RST
mmm packages/apps/$1
echo ""
echo -e $CL_RED"Done."$CL_RST
