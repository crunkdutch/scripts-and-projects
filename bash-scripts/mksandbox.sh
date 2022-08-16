#!/bin/bash 
CWD=`pwd`
PROJECTNAME=$1
SVNPATH=https://fcbhealthcare.svn.cvsdude.com/$PROJECTNAME/branches
HOSTNAME=$PROJECTNAME.stage.ddfcb.com


DEVELOPER=$2
DEVELOPER_DOCROOT=/home/$DEVELOPER/sandbox/_projects/$PROJECTNAME
DEVELOPER_HOSTNAME=$DEVELOPER-$HOSTNAME


if [ -z $PROJECTNAME -o -z $DEVELOPER ]
then
  echo "Usage: (sudo) mksandbox [projectname] [developername]"
  echo "For a valid user, this script will:"
  echo "Create sprint branch if not already there."
  echo "Create developer docroot using developer's user context."
  exit
fi

if [ `grep $DEVELOPER /etc/passwd | cut -d: -f1 | grep ^$DEVELOPER$ | wc -l` -ne 1 ]
        then
                echo "User name "$DEVELOPER" not found in /etc/passwd. Exiting."
                exit 1
        fi

if [ `svn info $SVNPATH | grep "svn: Could not open the requested SVN filesystem" | wc -l` -ge 1 ]
        then
                echo "SVN project "$PROJECTNAME"/branches does not exist. Exiting."
                exit 1
        fi

if [ `svn ls $SVNPATH | grep ^sprint1\/$ | wc -l` -eq 1 ]
        then
                echo "/sprint1 dir already found in repo. Skipping."
        else
                echo "Creating sprint1 filesystem at "$SVNPATH"\/sprint1"
                svn mkdir $SVNPATH/sprint1 -m "creating sprint1"
        fi

# Create developer docroot

if [ -d $DEVELOPER_DOCROOT ]
	then
		echo "Developer document root already created. Exiting."
		exit 1
	fi

echo "Creating Developer docroot at "$DEVELOPER_DOCROOT
sudo -i -u $DEVELOPER mkdir -p $DEVELOPER_DOCROOT

# Write out test.htm file to docroot
sudo -i -u $DEVELOPER echo "IT_WORKS "`date` >> $DEVELOPER_DOCROOT/test.htm

chown $DEVELOPER:apache $DEVELOPER_DOCROOT . -R

if [ `grep -i ServerName /etc/httpd/conf/httpd.conf | grep -i " "$DEVELOPER_HOSTNAME$ | wc -l` -ge 1 ]
        then
                echo "Found existing vhost "$DEVELOPER_HOSTNAME" in apache configuration. Skipping."
        else
		echo "Adding apache vhost to /etc/httpd/conf/httpd.conf"
		cat >> /etc/httpd/conf/httpd.conf << EOF

<VirtualHost *:80>
	DocumentRoot "$DEVELOPER_DOCROOT"
        ServerName $DEVELOPER_HOSTNAME
        CustomLog logs/$DEVELOPER_HOSTNAME-access_log combined
        ErrorLog logs/$DEVELOPER_HOSTNAME-error_log
	<Directory "$DEVELOPER_DOCROOT">
		Order allow,deny
		Allow from 50.58.117.34
		Allow from 127.0.0.1
                Options -Indexes
                AllowOverride All
        </Directory>
</VirtualHost>

EOF
# ^Remeber this EOF needs to be in column 1. Do not indent!!!

	echo "Checking apache syntax..."
	if [ `/usr/sbin/apachectl -t 2>&1 | grep "Syntax OK" | wc -l` -ne 1 ]
        	then
                	echo "Apache syntax problem. Exiting"
                	exit 1
        	fi
	echo "Apache syntax OK. Restarting apache"

	# Restarting apache
	/etc/init.d/httpd restart

	if [ `curl http://localhost/test.htm -H "Host: "$DEVELOPER_HOSTNAME -f -s | grep "IT_WORKS" | wc -l` -ne 1 ]
        	then
                	echo "HTTP get to test.htm file failed. Exiting."
                	exit 1
        	fi
	echo "Successful wget of test.htm from vhost "$DEVELOPER_HOSTNAME
	
	fi

echo "checking out "$SVNPATH"/sprint1 into "$DEVELOPER_DOCROOT

sudo -i -u $DEVELOPER svn co $SVNPATH/sprint1/ $DEVELOPER_DOCROOT/

cd $CWD



