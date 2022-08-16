#!/bin/bash 
USERNAME=$1
HOSTNAME=$USERNAME.stage.ddfcb.com
SANDBOX_DIR=/home/$USERNAME/sandbox/_projects/$HOSTNAME

# If there is no username
if [ -z $USERNAME ];
then
  echo "Usage: (sudo) mkacct [username]"
  echo "Creates user, sandbox and vhost"
  exit 
fi

if [ $EUID -ne 0 ]
then
	echo "This script must be run as root"
	exit 1
fi

if [ `grep $USERNAME /etc/passwd | cut -d: -f1 | grep ^$USERNAME$` ] 
	then
		echo "User name found in /etc/passwd. Exiting."
		exit 1
	fi

if [ -d $SANDBOX_DIR ]
	then
		echo "Sandbox directory "$SANDBOX_DIR" exists. Exiting."
		exit 1
	fi

if [ `/usr/sbin/apachectl -S 2>&1 | grep $HOSTNAME | cut -d" " -f13 | grep ^$HOSTNAME$` ]
	then
		echo "vhost already configured for "$HOSTNAME". Exiting."
		exit 1
	fi

echo "Pre-flight checks complete."
echo "Adding user."

# Adding user
/usr/sbin/useradd $USERNAME

# Have user create files with default group 'users'
/usr/sbin/usermod -g users $USERNAME

# Add to apache group for good measure
/usr/sbin/usermod -G apache -a $USERNAME

# Write umask of 002 to .bash_profile so that apache can write to directories created by user
echo "umask 002" >> /home/$USERNAME/.bash_profile

echo "/etc/passwd entry now is:"
grep ^$USERNAME: /etc/passwd

echo "User is in the following groups:"
grep $USERNAME /etc/group

# Write test file to sandbox home directory
echo "Creating directory "$SANDBOX_DIR
mkdir -p /home/$USERNAME/sandbox/_projects/$HOSTNAME
echo "IT_WORKS:"$USERNAME:" "`date` >> $SANDBOX_DIR/test.htm

#Cleaning up permissions
chown $USERNAME:users /home/$USERNAME/. -R
chmod 755 /home/$USERNAME/

cat >> /etc/httpd/conf/httpd.conf << EOF

<VirtualHost *:80>
	DocumentRoot "$SANDBOX_DIR"
	ServerName $HOSTNAME
	CustomLog logs/$HOSTNAME-access_log combined
        ErrorLog logs/$HOSTNAME-error_log
	<Directory "$SANDBOX_DIR">
		allow from all
		Options -Indexes
		AllowOverride All
	</Directory>
</VirtualHost>

EOF
	
if [ `/usr/sbin/apachectl -t 2>&1 | grep "Syntax OK" | wc -l` -ne 1 ]
	then
		echo "Apache syntax problem. Exiting"
		exit 1
	fi

# Restarting apache
/etc/init.d/httpd restart


# Check to see if test.htm file is available at new vhost
if [ `curl http://localhost/test.htm -H "Host: "$HOSTNAME -f -s | grep "IT_WORKS:"$USERNAME | wc -l` -ne 1 ]
        then
                echo "HTTP get to test.htm file not working. Exiting."
                exit 1
        fi

echo "Successful wget of test.htm from vhost "$HOSTNAME

echo "Please set the password for the user "$USERNAME
passwd $USERNAME

echo "Requiring password reset, setting password expiration to 60 days for user "$USERNAME
chage -m 0 -M 60 -W 7 -d 0 -I 30 $USERNAME
chage -l $USERNAME
