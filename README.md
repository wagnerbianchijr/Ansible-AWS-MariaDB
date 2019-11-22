# Ansible-AWS-MariaDB
Ansible Roles for creating an AWS simple infrastructure, with instances with MariaDB in replication and a MaxScale with MariaDBMon and ReadWriteSplit Router. Before starting up running Ansible Roles to bootstrap resources on your behalf calling the AWS API, make sure you create a user with Programmatic Access and add the best policy/permission. After creating the user, make sure you download the .csv file as when you get off that page, you won't see it again! The vars you need to configure is at bianchi-aws-bootstrap/vars/main.yml, as below:

```
# vars file for /etc/ansible/roles/aws-bootstrap

#: credentials - create a user on 
#: IAM with Programmatic Access
aws_access_key: ""
aws_secret_key: ""
region: ""
az: ""
```
Also, make sure you create an SSH key and import the key to the console.  I suggest you to create a key named 'ansible' and configure that also in the bianchi-aws-bootstrap/vars/main.yml file.

***Roles***:

- ***bianchi-aws-bootstrap***: creates a VPC, an Internet Gateway, a Public Subnet, a Route Table associating the Internet Gateway and the Public Subent, a Security Group configuring inbound access to ports 22 and 3306 and spin up 4 public accessible instances - 1 for MaxScale tagged mxserver01, and 3 others for MariaDB Servers (dbserver01, dbserver02, and dbserver03). The database user and their GRANTs will be added on the master (users for MaxScale['maxusr','maxmon','mariadb']). Other small things are also done like set up the server's motd with the machine's names and change the .bash_profile for each user to obtain a colored one. 

To make things easier, the bootstrap role will create a local static inventory. You should create manually an inventory file like the one below before running the role:
```
ansible ansible_ssh_host=localhost ansible_ssh_port=22

[dbservers]
#dbservers

[mxservers]
#mxservers
```
The role will populate the hosts file so you can configure a ~/.ssh/config file to access instances by the name:
```
[BIANCHI LABS - ansible] ansible@jumphost: ~ $ cat .ssh/config
Host mxserver01
  Hostname mxserver01
  User ec2-user
  ForwardAgent yes

Host dbserver01
  Hostname dbserver01
  User ec2-user
  ForwardAgent yes

Host dbserver02
  Hostname dbserver02
  User ec2-user
  ForwardAgent yes

Host dbserver03
  Hostname dbserver03
  User ec2-user
  ForwardAgent yes
```  
- ***bianchi-aws-dbservers***: access dbserver0* tagged instances and set up the MariaDB Server 10.3:latest, add configurations, and restart the service (mariadb.service). Finally, the role will configure the positional replication on dbserver02, and dbserver03 off dbserver01.

- ***bianchi-aws-mxservers***: access the mxserver01 tagged instance and add configurations. For the date, it does not yet work on [server] sections Private IPs. (It's going to be done soon). The whole set of configurations will, although, be in place for starting up MaxScale with users with encrypted passwords for the sake of security, the MariaDBMon Monitor with auto_failover, and auto_rejoin enabled, The ReadWriteSplit Router configured as a service with a listener on port 3306. Here, ***don't forget to change the Private IPs manually added for the server's sections as the ones added currently are yet wrong!***

Once you have roles on the right place, you can execute like below:
```
$ ansible-playbook /etc/ansible/roles/bianchi-aws-bootstrap/bianchi-aws-bootstrap.yml
$ ansible-playbook /etc/ansible/roles/bianchi-aws-dbservers/bianchi-aws-dbservers.yml
$ ansible-playbook /etc/ansible/roles/bianchi-aws-mxservers/bianchi-aws-mxservers.yml
```
***Bad practices to be removed soon (I'll do it soon, be aware if you use it)***:

- do not run ANY of your EC2 instances with the ec2user and ANY of the default users provided by ANY of the exeisting AMIs. Create your own user with a strong passphrased SSH key and remove the ec2-user;
- do not agree just on NACL or Security Groups, you need firewall also on instances. I recommend you to configure fail2ban to dynamically filter ban/unban IPs scanning ports of your instances.

***Access the Gist with the roles execution output***
https://gist.github.com/wagnerbianchijr/d9a3ae8db80fd5a9c92e328aa6e281b4
