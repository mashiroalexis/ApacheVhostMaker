#!/bin/bash

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

# Validate input
if [ -z "$1" ]; then
    echo "Error: No sitename.domain provided"
    echo "Usage: sudo bash ~/vhost/new-vhost.sh [sitename.domain]"
    exit 1
fi

# Create necessary directories
mkdir -p /opt/lampp/htdocs/$1/public_html/public
mkdir -p /opt/lampp/htdocs/logs/$1

# Add user to apache group
usermod -a -G www-data $USER

# Set file ownership and permissions
chown -R www-data:www-data /opt/lampp/htdocs/$1
chmod -R 0755 /opt/lampp/htdocs/$1

# Create a sample index.html file
cat > /opt/lampp/htdocs/$1/public_html/public/index.html <<EOF
<html>
  <head>
    <title>Welcome to $1!</title>
  </head>
  <body>
    <h1>Success! The $1 virtual host is working!</h1>
  </body>
</html>
EOF

# Create a placeholder file for .git
cat > /opt/lampp/htdocs/$1/public_html/put_git_here.txt <<EOF
put .git here and not in public folder!
EOF

# Add the virtual host configuration to httpd-vhosts.conf
cat >> /opt/lampp/etc/extra/httpd-vhosts.conf <<EOF

<VirtualHost *:80>
    ServerAdmin admin@$1
    ServerName $1
    ServerAlias www.$1
    DocumentRoot /opt/lampp/htdocs/$1/public_html/public
    ErrorLog /opt/lampp/htdocs/logs/$1/error.log
    CustomLog /opt/lampp/htdocs/logs/$1/access.log combined

    <Directory /opt/lampp/htdocs/$1/public_html/public>
        Options -Indexes
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# Test Apache configuration using XAMPP's httpd
/opt/lampp/bin/httpd -t
if [ $? -ne 0 ]; then
    echo "Apache configuration error. Please check the configuration."
    exit 1
fi

# Restart Apache server
/opt/lampp/lampp restart

# Add the domain to /etc/hosts for local testing
echo "127.0.0.1 $1" >> /etc/hosts

echo "Virtual host $1 created and added to /opt/lampp/etc/extra/httpd-vhosts.conf."

# for the ubuntu lampp refactored code i need you to
# Make a version of this for XAMPP MacOS
# this is the htdocs location: /Applications/XAMPP/xamppfiles/htdocs
# this is the vhosts file location: /Applications/XAMPP/xamppfiles/etc/extra/httpd-vhosts.conf
# Remove this "public_html/public" no need or make $1 as default and also make it to accept string for custom path
# also remote the placeholder file for .git
# Use this code to restart the XAMPP "sudo /Applications/XAMPP/xamppfiles/xampp restart"


# here are some changes i want to make
# remove sudo for restarting xampp
# check what if xampp is not started yet? do you restart it or just start it
# check line by line for any bug that might occur and fix it.