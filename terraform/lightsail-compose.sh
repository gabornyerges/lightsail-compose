#!/bin/bash

# copy the dockerfile into /srv/docker
# if you change this, change the systemd service file to match
# WorkingDirectory=[whatever you have below]
mkdir /srv/docker
curl -o /srv/docker/docker-compose.yml \
https://raw.githubusercontent.com/gabornyerges/lightsail-compose/master/docker-compose.yaml

# install docker-compose
curl -L https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m) \
 -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# install latest version of docker the lazy way
HOST_OS=$(cat /etc/issue | head -n 1)
if  [[ $HOST_OS == Amazon* ]] ;then
  sudo yum update -y
  sudo yum install docker -y
  sudo service docker start
  sudo usermod -a -G docker ec2-user
  sudo curl -o /etc/init.d/docker-compose-wordpress https://raw.githubusercontent.com/gabornyerges/lightsail-compose/master/terraform/etc-init.d-docker-compose
  sudo chmod +x /etc/init.d/docker-compose-wordpress
  sudo chkconfig --add docker-compose-wordpress
  sudo chkconfig docker-compose-wordpress on
  reboot
elif [[ $HOST_OS == Ubuntu* ]]; then
  curl -sSL https://get.docker.com | sh
  usermod -aG docker ubuntu
  # copy in systemd unit file and register it so our compose file runs
  # on system restart
  curl -o /etc/systemd/system/docker-compose-app.service https://raw.githubusercontent.com/gabornyerges/lightsail-compose/master/terraform/docker-compose-app.service
  systemctl enable docker-compose-app
  # start up the application via docker-compose
  docker-compose -f /srv/docker/docker-compose.yml up -d
fi



