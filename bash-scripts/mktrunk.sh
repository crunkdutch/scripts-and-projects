#!/bin/bash

PROJECTNAME=$1
DOCROOT=/var/www/clients/$PROJECTNAME
SVNPATH=https://fcbhealthcare.svn.cvsdude.com/$PROJECTNAME
HOSTNAME=$PROJECTNAME.stage.ddfcb.com


# Create trunk, tags, branches

if [ -z $PROJECTNAME ]
then
  echo "Usage: (sudo) mktrunk [projectname]"
  echo "Creates trunk, tags, branches in svn. Creates docroot and does initial check in."
  exit
fi
echo "Creating trunk, tags, branches"
if [ `svn ls $SVNPATH | grep ^trunk\/$ | wc -l` -eq 1 ]
	then
		echo "\/trunk dir already found in repo. Skipping."
	else
		echo "Creating trunk filesystem at "$SVNPATH"\/trunk\/"
		svn mkdir $SVNPATH/trunk -m "creating trunk" 
	fi

if [ `svn ls $SVNPATH | grep ^tags\/$ | wc -l` -eq 1 ]
        then
                echo "/tags dir already found in repo. Skipping."
        else
                echo "Creating tags filesystem at "$SVNPATH"/tags"
                svn mkdir $SVNPATH/tags -m "creating tags"
        fi

if [ `svn ls $SVNPATH | grep ^branches\/$ | wc -l` -eq 1 ]
        then
                echo "/branches dir already found in repo. Skipping."
        else
                echo "Creating branches filesystem at "$SVNPATH"/branches"
                svn mkdir $SVNPATH/branches -m "creating branches"
        fi