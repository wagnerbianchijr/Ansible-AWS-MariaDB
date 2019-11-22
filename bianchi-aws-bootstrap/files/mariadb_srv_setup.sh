#!/bin/bash
#: mariadb_srv_setup.sh

#: yum initial operations
sudo yum -y install epel-release
sudo yum -y install rsync wget psmisc net-tools vim htop iptraf iftop socat

#: firewalld and SELinux
sudo systemctl stop firewalld > /dev/null
sudo systemctl disable firewalld > /dev/null

#: adding the repository
sudo cat << EOF >> /etc/yum.repos.d/MariaDB103.repo
# MariaDB 10.3 CentOS repository list
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

#: yum operations
sudo yum -y update
sudo yum -y install MariaDB-client MariaDB-server MariaDB-backup
