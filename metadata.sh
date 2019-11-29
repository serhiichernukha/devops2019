#!/bin/bash
#Instaling required pakages

dnf update -y
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install --nobest docker-ce -y
systemctl enable --now docker

# Restart Docker
sudo systemctl enable docker
sudo systemctl start docker

docker pull jenkins/jenkins:lts

# local jenkins home
mkdir -p /var/jenkins
chown 1000 /var/jenkins

echo 'FROM jenkins/jenkins:lts
COPY --from=lachlanevenson/k8s-kubectl:v1.10.3 /usr/local/bin/kubectl /usr/local/bin/kubectl
USER root
RUN apt-get update && \
    apt-get -y install apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable"
USER jenkins' \
> /root/Dockerfile
docker build -t my_jenkins /root
docker run -d -p 8080:8080 -p 2375:2375 -p 4243:4243 \
 -v /var/jenkins:/var/jenkins_home \
 --restart unless-stopped \
 -v /var/run/docker.sock:/var/run/docker.sock \
 -v $(which docker):$(which docker) \
 my_jenkins:latest
container=$(sudo docker ps | grep my_jenkins | cut -c '1-12')
docker container exec -u 0 $container wget http://updates.jenkins-ci.org/download/war/2.190.3/jenkins.war
docker container exec -u 0 $container mv ./jenkins.war /usr/share/jenkins
docker container exec -u 0 $container chown jenkins:jenkins /usr/share/jenkins/jenkins.war
docker container restart $container


#Config firewall
sudo firewall-cmd --permanent --zone=public --add-port=8080/tcp
sudo firewall-cmd --reload



#use token (example: 11c233de1980616041182cdc75e6d2e2c3) for auth method.
#you can set environtment variables do this method easier:
#export JENKINS_USER_ID=(username)
#export JENKINS_API_TOKEN=(token)
#sudo cp /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar /home/intkoost
