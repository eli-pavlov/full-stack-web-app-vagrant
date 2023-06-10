#!/bin/bash
sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sudo yum install epel-release -y
sudo yum install memcached -y
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached
sudo sleep 5
sudo memcached -p 11211 -U 11111 -u memcached -d
