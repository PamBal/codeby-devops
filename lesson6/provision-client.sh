#!/bin/bash
set -e

if ! grep -q "192.168.56.10 server" /etc/hosts; then
    echo "192.168.56.10 server" >> /etc/hosts
fi


install -d -m 700 -o vagrant -g vagrant /home/vagrant/.ssh


if [ ! -f /home/vagrant/.ssh/lesson6_key ]; then
    runuser -u vagrant -- ssh-keygen \
        -t ed25519 \
        -f /home/vagrant/.ssh/lesson6_key \
        -N ""
fi


mkdir -p /vagrant/.vagrant
cp /home/vagrant/.ssh/lesson6_key.pub \
   /vagrant/.vagrant/lesson6_client.pub

