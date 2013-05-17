#!/bin/sh

cm=${1}
cdate=`date +"%Y-%m-%d"`
rdir=`pwd`
pd=${2}

clear

# Check the date start range is set
if [ -z "$cm" ]; then
echo " "
echo "ATTENTION: Start date not defined ----------------------------------------------------"
    echo " "
    echo " >>> Please define a start date in yyyy/mm/dd/ format ..."
    echo " "
    echo "----------------------------------------------------------------------------------"
    read sdate
fi

# Find the directories to log
echo " ";echo " ";echo " "
echo "${2} CHANGELOG -------------------------------------------------------------------------"
echo " "
find $rdir -name .git | sed 's/\/.git//g' | sed 'N;$!P;$!D;$d' | while read line
do
cd $line
    # Test to see if the repo needs to have a changelog written.
    log=$(git log --pretty="%an - %s" --date-order -$cm)
    project="MIRAGE"
    if [ -z "$log" ]; then
echo " >>> Nothing updated on $project changelog, skipping ..."
    else
        # Write the changelog
        echo " >>> Changelog is updated and written for $project ..."
        echo "Project name: $pd" >> ~/bin/Changelog/Changelog_${2}_$cdate.log
        echo "$log" | while read line
        do
echo " •$line" >> ~/bin/Changelog/Changelog_${2}_$cdate.log
        done
echo " " >> ~/bin/Changelog/Changelog_${2}_$cdate.log
    fi
done
echo " "
echo "------------------------------------------------------------------------------------"
echo " ";echo " ";echo " "
