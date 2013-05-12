#!/bin/sh
. colors

cm=${1}
cdate=`date +"%Y-%m-%d"`
rdir=`pwd`
pd=${2}

clear

# Check the date start range is set
if [ -z "$cm" ]; then
echo " "
echo -e $CL_RED"ATTENTION: Start date not defined ----------------------------------------------------"
    echo " "
    echo " >>> Please define a start date in yyyy/mm/dd/ format ..."
    echo " "
    echo "----------------------------------------------------------------------------------"$CL_RST
    read sdate
fi

# Find the directories to log
echo " ";echo " ";echo " "
echo -e $CL_CYN"${2} CHANGELOG -------------------------------------------------------------------------"$CL_RST
echo " "
find $rdir -name .git | sed 's/\/.git//g' | sed 'N;$!P;$!D;$d' | while read line
do
cd $line
    # Test to see if the repo needs to have a changelog written.
    log=$(git log --pretty="%an - %s" --date-order -$cm)
    project="MIRAGE"
    if [ -z "$log" ]; then
echo -e $CL_YLW" >>> Nothing updated on $project changelog, skipping ..."$CL_RST
    else
        # Write the changelog
        echo -e $CL_BLU" >>> Changelog is updated and written for $project ..."$CL_RST
        echo "Project name: $pd" >> ~/bin/Changelog/Changelog_${2}_$cdate.log
        echo "$log" | while read line
        do
echo " •$line" >> ~/bin/Changelog/Changelog_${2}_$cdate.log
        done
echo " " >> ~/bin/Changelog/Changelog_${2}_$cdate.log
    fi
done
echo " "
echo $CL_CYN"------------------------------------------------------------------------------------"$CL_RST
echo " ";echo " ";echo " "
