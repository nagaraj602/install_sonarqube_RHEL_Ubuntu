#!/bin/bash
distro=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f2 | sed 's/"//g')

echo "Installing SonarQube on $distro.."

if [ "$distro" == "rhel" ]; then
	sudo yum update -y > /dev/null 2>&1
	sudo yum install wget unzip java-25-openjdk -y > /dev/null 2>&1


elif [ "$distro" == "ubuntu" ]; then
	sudo apt-get update -y > /dev/null 2>&1
	sudo apt-get install -y openjdk-25-jre unzip > /dev/null 2>&1

else
    echo "Unsupported Distribution - Only RHEL and Ubuntu are supported by this Script!!!!"
    exit 1
fi

cd /tmp
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-26.3.0.120487.zip
sudo unzip sonarqube-26.3.0.120487.zip 1>/dev/null
sudo rm -rf sonarqube-26.3.0.120487.zip

sudo mv sonarqube-26.3.0.120487 /opt/sonarqube
sudo chown -R ubuntu: /opt/sonarqube/*
sudo chown -R ubuntu: /opt/sonarqube
cd /opt
sudo su -m ubuntu -c "./sonarqube/bin/linux-x86-64/sonar.sh start 1>/dev/null"


# Check if SonarQube is working
echo "\n################################################################ \n"
if [ $? -eq 0 ]; then
	echo "SonarQube installed Successfully"
	echo "Access SonarQube using $(curl -s ifconfig.me):9000"
	echo "User: admin"
	echo "Password: admin"
else
	echo "SonarQube installation failed"
fi
echo "\n################################################################ \n"
