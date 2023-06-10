# adding repository and installing nginx
sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf
apt update -y
apt install nginx -y
cat <<EOT > vproapp
upstream vproapp {

 server app01:8080;

}

server {

  listen 80;

location / {

  proxy_pass http://vproapp;

}

}

EOT

sudo mv vproapp /etc/nginx/sites-available/vproapp
sudo rm -rf /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

#starting nginx service and firewall
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx
