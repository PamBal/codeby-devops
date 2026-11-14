#!/bin/bash
set -e

PUBLIC_KEY="/vagrant/.vagrant/lesson6_client.pub"


if [ ! -s "$PUBLIC_KEY" ]; then
    echo "Error: client public key not found"
    exit 1
fi

install -d -m 700 -o vagrant -g vagrant /home/vagrant/.ssh

touch /home/vagrant/.ssh/authorized_keys


if ! grep -qxF "$(cat "$PUBLIC_KEY")" /home/vagrant/.ssh/authorized_keys; then
    cat "$PUBLIC_KEY" >> /home/vagrant/.ssh/authorized_keys
fi


chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
chmod 600 /home/vagrant/.ssh/authorized_keys

