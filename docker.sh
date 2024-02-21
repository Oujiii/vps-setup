#!/bin/bash

#install docker and docker-compose and ufw-docker

#Get the script install from Docker website and execute it
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo "Docker was installed"

#Get the script install from Docker website and execute it 
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose


echo "Docker-compose was installed"

#Install ufw-docker

sudo wget -O /usr/local/bin/ufw-docker \
  https://github.com/chaifeng/ufw-docker/raw/master/ufw-docker
sudo chmod +x /usr/local/bin/ufw-docker
sudo ufw-docker install
sudo systemctl restart ufw
  
echo "UFW-Docker was installed"
