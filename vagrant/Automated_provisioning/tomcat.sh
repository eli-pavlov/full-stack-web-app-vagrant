#TOMURL="https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz"
sudo echo "nameserver 8.8.8.8" >> /etc/resolv.conf
sudo yum install java-1.8.0-openjdk -y
sudo yum install git maven wget -y
#sudo cd /tmp/
#sudo wget $TOMURL -O tomcatbin.tar.gz
#EXTOUT=`tar xzvf tomcatbin.tar.gz`
#TOMDIR=`echo $EXTOUT | cut -d '/' -f1`
#sudo useradd --shell /sbin/nologin tomcat
sudo mkdir /usr/local/tomcat8 -p
sudo useradd --home-dir /usr/local/tomcat8 --shell /sbin/nologin tomcat
sudo groupadd tomcat
sudo chown -R tomcat:tomcat /usr/local/tomcat8
sudo wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.37/bin/apache-tomcat-8.5.37.tar.gz
sudo tar xzvf apache-tomcat-8.5.37.tar.gz
sudo cp -r /home/vagrant/apache-tomcat-8.5.37/* /usr/local/tomcat8/
#sudo rsync -avzh /tmp/$TOMDIR/ /usr/local/tomcat8/
sudo chown tomcat:tomcat /usr/local/tomcat8 -R
sudo rm -rf /etc/systemd/system/tomcat.service

sudo cat <<EOT>> /etc/systemd/system/tomcat.service
[Unit]
Description=Tomcat
After=network.target

[Service]

User=tomcat
Group=tomcat

WorkingDirectory=/usr/local/tomcat8

Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre

Environment=CATALINA_PID=/var/tomcat/%i/run/tomcat.pid
Environment=CATALINA_HOME=/usr/local/tomcat8
Environment=CATALINE_BASE=/usr/local/tomcat8

ExecStart=/usr/local/tomcat8/bin/catalina.sh run
ExecStop=/usr/local/tomcat8/bin/shutdown.sh


RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target

EOT

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat

sudo git clone -b local-setup https://github.com/devopshydclub/vprofile-project.git
sudo cd vprofile-project/
cd vprofile-project/
sudo cp /home/vagrant/vprofile-project/* ./ -R
sudo mvn install
sudo systemctl stop tomcat
sudo sleep 60
sudo rm -rf /usr/local/tomcat8/webapps/ROOT*
sudo cp target/vprofile-v2.war /usr/local/tomcat8/webapps/ROOT.war
sudo systemctl start tomcat
sudo sleep 120
sudo cp /vagrant/application.properties /usr/local/tomcat8/webapps/ROOT/WEB-INF/classes/application.properties
sudo systemctl restart tomcat
