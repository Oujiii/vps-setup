#!/bin/bash

#install docker and docker-compose and ufw-docker

#Get the script install from Docker website and execute it
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "Docker was installed"

#Get the script install from Docker website and execute it 
curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

echo "Docker-compose was installed"

#Install ufw-docker

sudo wget -O /usr/local/bin/ufw-docker \
  https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
sudo chmod +x /usr/local/bin/ufw-docker
sudo ufw-docker install
sudo systemctl restart ufw
  
echo "UFW-Docker was installed"
