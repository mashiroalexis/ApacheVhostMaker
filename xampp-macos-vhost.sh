#!/bin/bash

# Usage:
# bash ./xampp-macos-vhost.sh sitename.domain [custom/path]
# Example:
# bash ./xampp-macos-vhost.sh webtest.org /public
# This will set the document root to /Applications/XAMPP/xamppfiles/htdocs/webtest.org/public
# If custom path is not provided, it will default to /Applications/XAMPP/xamppfiles/htdocs/sitename.domain

# Function to check and uncomment the Include line in httpd.conf
uncomment_include_vhosts() {
    local conf_file="/Applications/XAMPP/xamppfiles/etc/httpd.conf"
    local include_line="Include etc/extra/httpd-vhosts.conf"

    if grep -q "^#.*$include_line" "$conf_file"; then
        echo "Uncommenting the Include line in $conf_file..."
        sudo sed -i '' "s|^#\s*${include_line}|${include_line}|g" "$conf_file"
    else
        echo "Include line is already uncommented or not found in $conf_file."
    fi
}

# Validate input
if [ -z "$1" ]; then
  echo "Error: No sitename.domain provided"
  echo "Usage: bash ./xampp-macos-vhost.sh sitename.domain [custom/path]"
  exit 1
fi

SITENAME=$1
CUSTOM_PATH=$2
BASE_DOCUMENT_ROOT="/Applications/XAMPP/xamppfiles/htdocs/$SITENAME"
DOCUMENT_ROOT="$BASE_DOCUMENT_ROOT${CUSTOM_PATH:-}"

# Ensure the document root is within the XAMPP htdocs directory
if [[ "$DOCUMENT_ROOT" != /Applications/XAMPP/xamppfiles/htdocs/* ]]; then
  echo "Error: Document root must be inside /Applications/XAMPP/xamppfiles/htdocs/"
  exit 1
fi

# Uncomment the Include line in httpd.conf
uncomment_include_vhosts

# Create necessary directories
mkdir -p "$DOCUMENT_ROOT"

# Set file ownership and permissions
chown -R $USER:staff "$DOCUMENT_ROOT"
chmod -R 0755 "$DOCUMENT_ROOT"

# Create a sample index.html file
cat > "$DOCUMENT_ROOT/index.html" <<EOF
<html>
  <head>
    <title>Welcome to $SITENAME!</title>
  </head>
  <body>
    <h1>Success! The $SITENAME virtual host is working!</h1>
  </body>
</html>
EOF

# Define vhost configuration
VHOST_CONF="<VirtualHost *:80>
    ServerAdmin admin@$SITENAME
    ServerName $SITENAME
    ServerAlias www.$SITENAME
    DocumentRoot \"$DOCUMENT_ROOT\"
    ErrorLog \"/Applications/XAMPP/xamppfiles/logs/$SITENAME-error.log\"
    CustomLog \"/Applications/XAMPP/xamppfiles/logs/$SITENAME-access.log\" combined

    <Directory \"$DOCUMENT_ROOT\">
        Options -Indexes
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>"

# Update /etc/hosts file to include the new hostname
if ! grep -q "$SITENAME" /etc/hosts; then
  echo "127.0.0.1 $SITENAME" | sudo tee -a /etc/hosts > /dev/null
  echo "Added $SITENAME to /etc/hosts"
else
  echo "$SITENAME already exists in /etc/hosts"
fi

# Check for existing virtual host entry
if grep -q "ServerName $SITENAME" /Applications/XAMPP/xamppfiles/etc/extra/httpd-vhosts.conf; then
  echo "Virtual host for $SITENAME already exists in httpd-vhosts.conf"
  exit 1
else
  # Add the virtual host configuration
  echo "$VHOST_CONF" | sudo tee -a /Applications/XAMPP/xamppfiles/etc/extra/httpd-vhosts.conf > /dev/null
  echo "Virtual host $SITENAME added to /Applications/XAMPP/xamppfiles/etc/extra/httpd-vhosts.conf"
fi

# Check if Apache is already running
if pgrep -x "httpd" > /dev/null; then
    echo "Another Apache server is already running. Stopping it..."
    sudo apachectl stop
fi

# Restart XAMPP
sudo /Applications/XAMPP/xamppfiles/xampp restart

# Check if Apache is running
if pgrep -x "httpd" > /dev/null; then
    echo "Apache is running successfully."
else
    echo "Apache is not running. Please check the logs for errors."
    exit 1
fi

# Output success message
echo "Entry added to /etc/hosts and virtual host $SITENAME created. You can now visit http://$SITENAME/ in your browser."
