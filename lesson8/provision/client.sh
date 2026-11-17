
#!/bin/bash
set -euo pipefail

echo "=== Configuring /etc/hosts ==="

HOSTS_ENTRY="192.168.56.20 codeby.local www.codeby.local"

if ! grep -qxF "$HOSTS_ENTRY" /etc/hosts; then
    echo "$HOSTS_ENTRY" >> /etc/hosts
fi

echo "=== Hosts configured ==="


echo "=== Installing trusted SSL certificate ==="

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates openssl

CERT="/usr/local/share/ca-certificates/codeby.local.crt"

# Get public certificate from Apache server
openssl s_client \
    -connect 192.168.56.20:443 \
    -servername codeby.local \
    -showcerts </dev/null 2>/dev/null \
    | openssl x509 -out "$CERT"

# Update system trusted certificates
update-ca-certificates

echo "=== SSL certificate trusted ==="
