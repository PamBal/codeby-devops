
#!/bin/bash
set -euo pipefail

echo "=== Installing Apache ==="

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y apache2

systemctl enable --now apache2

cat > /var/www/html/index.html <<'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Lesson 8</title>
</head>
<body>
    <h1>Apache is working!</h1>
    <p>Lesson 8 - HTTPS configuration</p>
</body>
</html>
EOF

echo "=== Apache configured successfully ==="


echo "=== Generating self-signed SSL certificate ==="

CERT="/etc/ssl/certs/codeby.local.crt"
KEY="/etc/ssl/private/codeby.local.key"

if [[ ! -f "$CERT" || ! -f "$KEY" ]]; then
    openssl req -x509 \
        -newkey rsa:2048 \
        -sha256 \
        -nodes \
        -days 365 \
        -keyout "$KEY" \
        -out "$CERT" \
        -subj "/CN=codeby.local" \
        -addext "subjectAltName=DNS:codeby.local,DNS:www.codeby.local"

    chmod 600 "$KEY"
    chmod 644 "$CERT"
fi

echo "=== SSL certificate ready ==="


echo "=== Configuring Apache HTTPS ==="

# Enable SSL module
a2enmod ssl

# Create HTTPS VirtualHost
cat > /etc/apache2/sites-available/codeby-ssl.conf <<'EOF'
# Main HTTPS website
<VirtualHost *:443>
    ServerName codeby.local
    DocumentRoot /var/www/html

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/codeby.local.crt
    SSLCertificateKeyFile /etc/ssl/private/codeby.local.key

    ErrorLog ${APACHE_LOG_DIR}/codeby-error.log
    CustomLog ${APACHE_LOG_DIR}/codeby-access.log combined
</VirtualHost>

# WWW redirect
<VirtualHost *:443>
    ServerName www.codeby.local

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/codeby.local.crt
    SSLCertificateKeyFile /etc/ssl/private/codeby.local.key

    Redirect permanent / https://codeby.local/
</VirtualHost>
EOF

# Enable HTTPS site
a2ensite codeby-ssl.conf

# Check configuration
apache2ctl configtest

# Apply configuration
systemctl reload apache2

echo "=== Apache HTTPS configured ==="


echo "=== Configuring HTTP to HTTPS redirect ==="

cat > /etc/apache2/sites-available/codeby-http.conf <<'EOF'
<VirtualHost *:80>
    ServerName codeby.local
    ServerAlias www.codeby.local

    Redirect permanent / https://codeby.local/

    ErrorLog ${APACHE_LOG_DIR}/codeby-http-error.log
    CustomLog ${APACHE_LOG_DIR}/codeby-http-access.log combined
</VirtualHost>
EOF

# Enable HTTP VirtualHost
a2ensite codeby-http.conf

# Check configuration
apache2ctl configtest

# Apply changes
systemctl reload apache2

echo "=== HTTP redirect configured ==="

