#!/bin/bash

#: yum initial operations
sudo yum -y install epel-release
sudo yum -y install rsync wget psmisc net-tools vim htop iptraf iftop socat

#: firewalld and SELinux
sudo systemctl stop firewalld > /dev/null
sudo systemctl disable firewalld > /dev/null

#: setting up the repository
curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash

#: setting up MaxScale and MaxScale experimental
sudo yum -y install maxscale maxscale-experimental

#: remove the template in place
sudo rm -rf /etc/maxscale.cnf
sudo touch /etc/maxscale.cnf

#: adding a configuration file
sudo cat << EOF >> /etc/maxscale.cnf
[maxscale]
threads                     = auto
log_augmentation            = 1
ms_timestamp                = 1
syslog                      = 1

[rwsplit-service]
type                        = service
router                      = readwritesplit
user                        = maxusr
password                    = 123
max_sescmd_history          = 1500
causal_reads                = true
causal_reads_timeout        = 60
master_reconnection         = true
prune_sescmd_history        = true
master_failure_mode         = fail_on_write
EOF

#: starting up maxscale
sudo systemctl --now enable maxscale.service
