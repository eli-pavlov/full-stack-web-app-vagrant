#!/bin/bash
sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sudo yum install epel-release -y
sudo yum update -y
sudo yum install wget -y
sudo cd /tmp/
sudo wget http://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm
#wget http://packages.erlang-solutions.com/erlang-solutions-2.0-1.noarch.
sudo rpm -Uvh erlang-solutions-1.0-1.noarch.rpm
#sudo rpm -Uvh erlang-solutions-2.0-1.noarch.rpm
sudo yum update -y
sudo yum -y install erlang socat
sudo wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.35/rabbitmq-server-3.8.35-1.el8.noarch.rpm
#sudo wget https://www.rabbitmq.com/releases/rabbitmq-server/v3.6.1/rabbitmq-server-3.6.1-1.noarch.
sudo rpm --import https://www.rabbitmq.com/rabbitmq-signing-key-public.asc
sudo rpm -Uvh rabbitmq-server-3.8.35-1.el8.noarch.rpm
#curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash
#sudo yum install rabbitmq-server -y
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server