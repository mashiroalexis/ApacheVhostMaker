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

SITENAME=$1
BASE_DOCUMENT_ROOT="/opt/lampp/htdocs/$SITENAME"
DOCUMENT_ROOT="$BASE_DOCUMENT_ROOT/public_html/public"
LOGS_DIR="/opt/lampp/htdocs/logs/$SITENAME"
VHOST_CONF="/opt/lampp/etc/extra/httpd-vhosts.conf"

# Create necessary directories
mkdir -p "$DOCUMENT_ROOT"
mkdir -p "$LOGS_DIR"

# Add user to apache group
usermod -a -G www-data $USER

# Set file ownership and permissions
chown -R www-data:www-data "$BASE_DOCUMENT_ROOT"
chmod -R 0755 "$BASE_DOCUMENT_ROOT"

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

# Create a placeholder file for .git
cat > "$BASE_DOCUMENT_ROOT/public_html/put_git_here.txt" <<EOF
put .git here and not in public folder!
EOF

# Function to ensure the Include line is uncommented in httpd.conf
uncomment_include_vhosts() {
    local conf_file="/opt/lampp/etc/httpd.conf"
    local include_line="Include etc/extra/httpd-vhosts.conf"

    if grep -q "^#.*$include_line" "$conf_file"; then
        echo "Uncommenting the Include line in $conf_file..."
        sed -i "s|^#\s*$include_line|$include_line|g" "$conf_file"
    else
        echo "Include line is already uncommented or not found in $conf_file."
    fi
}

# Uncomment the Include line in httpd.conf
uncomment_include_vhosts

# Add the virtual host configuration to httpd-vhosts.conf
cat >> "$VHOST_CONF" <<EOF

<VirtualHost *:80>
    ServerAdmin admin@$SITENAME
    ServerName $SITENAME
    ServerAlias www.$SITENAME
    DocumentRoot $DOCUMENT_ROOT
    ErrorLog $LOGS_DIR/error.log
    CustomLog $LOGS_DIR/access.log combined

    <Directory $DOCUMENT_ROOT>
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
if ! grep -q "$SITENAME" /etc/hosts; then
    echo "127.0.0.1 $SITENAME" >> /etc/hosts
    echo "Added $SITENAME to /etc/hosts"
else
    echo "$SITENAME already exists in /etc/hosts"
fi

echo "Virtual host $SITENAME created and added to $VHOST_CONF."
