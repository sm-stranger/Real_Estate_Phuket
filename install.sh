#!/bin/bash

sudo apt update -y && sudo apt upgrade -y
sudo apt install -y mc


# Install Dependencies
sudo apt install -y nginx
sudo apt install -y python3 python3-dev python3-virtualenv
sudo apt install -y libxml2 libxml2-dev libxslt-dev
sudo apt install -y imagemagick curl
sudo apt install -y htop supervisor


# Install NodeJS:
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
source ~/.bashrc
nvm install v18.18.0


# Install Tomcat
sudo apt install -y openjdk-11-jdk
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat
VERSION=9.0.80
wget https://downloads.apache.org/tomcat/tomcat-9/v${VERSION}/bin/apache-tomcat-${VERSION}.tar.gz
sudo tar -xf apache-tomcat-${VERSION}.tar.gz -C /opt/tomcat/
sudo ln -s /opt/tomcat/apache-tomcat-${VERSION} /opt/tomcat/latest
sudo chown -R tomcat: /opt/tomcat
sudo sh -c 'chmod +x /opt/tomcat/latest/bin/*.sh'


sudo tee /etc/systemd/system/tomcat.service > /dev/null << EOF
[Unit]
Description=Tomcat 9 servlet container
After=network.target
[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom -Djava.awt.headless=true"
Environment="CATALINA_BASE=/opt/tomcat/latest"
Environment="CATALINA_HOME=/opt/tomcat/latest"
Environment="CATALINA_PID=/opt/tomcat/latest/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
ExecStart=/opt/tomcat/latest/bin/startup.sh
ExecStop=/opt/tomcat/latest/bin/shutdown.sh
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable --now tomcat
sudo ufw allow 8080/tcp






# Install Solr
#echo '<?xml version="1.0" encoding="utf-8"?><tomcat-users><role rolename="manager-gui"/><role rolename="admin-gui"/><user username="difiz" password="difizdesign" roles="manager-gui,admin-gui"/></tomcat-users>' > /etc/tomcat9/tomcat-users.xml

wget https://dlcdn.apache.org/solr/solr/9.3.0/solr-9.3.0.tgz | tar xf
tar xzf solr-9.3.0.tgz solr-9.3.0/bin/install_solr_service.sh --strip-components=2
sudo bash ./install_solr_service.sh solr-9.3.0.tgz

chown -R tomcat9:tomcat9 /var/lib/tomcat9/solr
service tomcat9 restart
```