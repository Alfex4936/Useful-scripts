#!/bin/sh
. colors

cd out/target/product/maguro
if [ ! -e "MIRAGE-maguro-4.2.2-FREEZE-v$1.zip" ]; then
          echo -e $CL_RED"There's no MIRAGE-maguro-4.2.2-FREEZE-v$1.zip file"$CL_RST
          echo -e $CL_RED"Please Check the version again"$CL_RST
   else
          echo -e $CL_YLW"Pushing MIRAGE-maguro-4.2.2-FREEZE-v$1.zip to /sdcard"$CL_RST 
          adb push MIRAGE-maguro-4.2.2-FREEZE-v$1.zip /sdcard/
          echo -e $CL_CYN"MIRAGE-maguro-4.2.2-FREEZE-v$1.zip pushed to /sdcard"$CL_RST
fi
echo -e $CL_CYN"Moving to top directory"$CL_RST
cd ../../../../
